//
//  GlideSwiftSDK.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

import Foundation
import Combine

import UIKit

public final class Glide {
    
    nonisolated(unsafe) public private(set) static var instance: Glide!
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    public static func configure(prepareUrl: String, processUrl: String) {
        let config = GlideConfiguration(prepareUrl: prepareUrl, processUrl: processUrl)
        let container = DIContainer(sdkConfig: config)
        Glide.instance = Glide(container: container)
    }
    
    private init(container: DIContainer) {
        self.container = container
    }
    
    public func start(phoneNumber: String, completion: @escaping (Result<(code: String, state: String), GlideSDKError>) -> Void) {
        guard validateSDKState(completion: completion) else { return }
        
        let config = container.getConfig()
        
        logger.info("Starting Glide SDK prepare flow")
        
        executeFlowChain(config: config, phoneNumber: phoneNumber)
            .sink(
                receiveCompletion: { [weak self] result in self?.handleCompletion(result: result, completion: completion) },
                receiveValue: { [weak self] result in self?.handleSuccess(result: result, completion: completion) }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    private func validateSDKState(completion: @escaping (Result<(code: String, state: String), GlideSDKError>) -> Void) -> Bool {
        guard Glide.instance != nil else {
            handleError(error: .sdkNotInitialized, completion: completion)
            return false
        }
        return true
    }
    
    private func executeFlowChain(config: GlideConfiguration, phoneNumber: String) -> AnyPublisher<(PrepareResponse, ProcessResponse), GlideSDKError> {
        let repository = container.provideRepository()
        
        return repository.executePrepare(url: config.prepareUrl, phoneNumber: phoneNumber)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .handleEvents(receiveOutput: { [weak self] prepareResponse in
                self?.openURL(urlString: prepareResponse.data.url)
            })
            .flatMap { [weak self] prepareResponse -> AnyPublisher<(PrepareResponse, InvokeResponse), GlideSDKError> in
                guard let self = self else {
                    return self?.failWithDeallocatedError() ?? Fail(error: GlideSDKError.unknown(NSError(domain: "Self deallocated", code: -1))).eraseToAnyPublisher()
                }
                return self.executeInvokeFlow(repository: repository, prepareResponse: prepareResponse)
            }
            .flatMap { [weak self] prepareResponse, invokeResponse -> AnyPublisher<(PrepareResponse, ProcessResponse), GlideSDKError> in
                guard let self = self else {
                    return Fail(error: GlideSDKError.unknown(NSError(domain: "Self deallocated", code: -1))).eraseToAnyPublisher()
                }
                return self.executeProcessFlow(repository: repository, prepareResponse: prepareResponse, invokeResponse: invokeResponse, url: config.processUrl, phoneNumber: phoneNumber)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func executeInvokeFlow(repository: Repository, prepareResponse: PrepareResponse) -> AnyPublisher<(PrepareResponse, InvokeResponse), GlideSDKError> {
        logger.info("Prepare flow succeeded with session key: \(prepareResponse.session.session_key)")
        logger.info("Starting invoke flow with status URL: \(prepareResponse.data.status_url)")
        
        return repository.executeInvoke(url: prepareResponse.data.status_url)
            .map { (prepareResponse, $0) }
            .eraseToAnyPublisher()
    }
    
    private func executeProcessFlow(repository: Repository, prepareResponse: PrepareResponse, invokeResponse: InvokeResponse, url: String, phoneNumber: String) -> AnyPublisher<(PrepareResponse, ProcessResponse), GlideSDKError> {
        logger.info("Invoke flow succeeded with status: \(invokeResponse.status)")
        logger.info("Starting process flow with session key: \(invokeResponse.session_key)")
        
        return repository.executeProcess(url: url, sessionKey: invokeResponse.session_key, phoneNumber: phoneNumber)
            .map { (prepareResponse, $0) }
            .eraseToAnyPublisher()
    }
    
    private func handleCompletion(result: Subscribers.Completion<GlideSDKError>, completion: @escaping (Result<(code: String, state: String), GlideSDKError>) -> Void) {
        switch result {
        case .failure(let error):
            logger.error("Flow failed: \(error.localizedDescription)")
            completion(.failure(error))
        case .finished:
            logger.info("All flows completed successfully")
        }
    }
    
    private func handleSuccess(result: (PrepareResponse, ProcessResponse), completion: @escaping (Result<(code: String, state: String), GlideSDKError>) -> Void) {
        let (prepareResponse, processResponse) = result
        logger.info("Process flow succeeded - Phone: \(processResponse.phone_number), Verified: \(processResponse.verified)")
        completion(.success((code: prepareResponse.session.session_key, state: prepareResponse.session.nonce)))
    }
    
    private func handleError(error: GlideSDKError, completion: @escaping (Result<(code: String, state: String), GlideSDKError>) -> Void) {
        logger.error(error.localizedDescription)
        completion(.failure(error))
    }
    
    private func failWithDeallocatedError<T>() -> AnyPublisher<T, GlideSDKError> {
        return Fail(error: GlideSDKError.unknown(NSError(domain: "Self deallocated", code: -1)))
            .eraseToAnyPublisher()
    }
    
    private func openURL(urlString: String) {
        guard let url = URL(string: urlString) else {
            logger.error("Invalid URL: \(urlString)")
            return
        }
        
        logger.info("Opening URL: \(urlString)")
        
        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                    logger.info("Successfully opened URL")
                } else {
                    logger.error("Failed to open URL")
                }
            }
        }
    }
    
}


