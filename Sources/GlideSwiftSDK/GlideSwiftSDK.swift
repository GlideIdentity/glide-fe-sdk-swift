//
//  GlideSwiftSDK.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

import Foundation
import Combine

public final class Glide {
    
    public static var instance: Glide!
    
    private let repository : Repository
    private var sdkConfig: GlideConfiguration!
    private var cancellables = Set<AnyCancellable>()
    
    public static func configure(prepareUrl: String, proccessUrl: String) {
        let apiRequestProvider = DefaultApiRequestProvider()
        let userAgentProvider = DefaultUserAgentProvider()
        let prepareFlow = PrepareFlow(apiRequestProvider: apiRequestProvider, userAgentProvider: userAgentProvider)
        let invokeFlow = InvokeFlow(apiRequestProvider: apiRequestProvider)
        let processFlow = ProcessFlow(apiRequestProvider: apiRequestProvider)
        Glide.instance = Glide(repository: GlideRepository(prepareFlow: prepareFlow, invokeFlow: invokeFlow, processFlow: processFlow))
        Glide.instance.sdkConfig = GlideConfiguration(prepareUrl: prepareUrl, proccessUrl: proccessUrl)
    }
    
    init(repository : Repository) {
        self.repository = repository
    }
    
    public func start(completion: @escaping (Result<(code: String, state: String), GlideSDKError>) -> Void) {
        guard validateSDKState(completion: completion) else { return }
        
        guard let config = sdkConfig else {
            handleError(error: .configurationMissing, completion: completion)
            return
        }
        
        logger.info("Starting Glide SDK prepare flow")
        
        executeFlowChain(config: config)
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
    
    private func executeFlowChain(config: GlideConfiguration) -> AnyPublisher<(PrepareResponse, ProcessResponse), GlideSDKError> {
        return repository.executePrepare(url: config.prepareUrl)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .flatMap { [weak self] prepareResponse -> AnyPublisher<(PrepareResponse, InvokeResponse), GlideSDKError> in
                guard let self = self else {
                    return self?.failWithDeallocatedError() ?? Fail(error: GlideSDKError.unknown(NSError(domain: "Self deallocated", code: -1))).eraseToAnyPublisher()
                }
                return self.executeInvokeFlow(prepareResponse: prepareResponse)
            }
            .flatMap { [weak self] prepareResponse, invokeResponse -> AnyPublisher<(PrepareResponse, ProcessResponse), GlideSDKError> in
                guard let self = self else {
                    return Fail(error: GlideSDKError.unknown(NSError(domain: "Self deallocated", code: -1))).eraseToAnyPublisher()
                }
                return self.executeProcessFlow(prepareResponse: prepareResponse, invokeResponse: invokeResponse, url: config.proccessUrl)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func executeInvokeFlow(prepareResponse: PrepareResponse) -> AnyPublisher<(PrepareResponse, InvokeResponse), GlideSDKError> {
        logger.info("Prepare flow succeeded with session key: \(prepareResponse.session.session_key)")
        logger.info("Starting invoke flow with status URL: \(prepareResponse.data.status_url)")
        
        return repository.executeInvoke(url: prepareResponse.data.status_url)
            .map { (prepareResponse, $0) }
            .eraseToAnyPublisher()
    }
    
    private func executeProcessFlow(prepareResponse: PrepareResponse, invokeResponse: InvokeResponse, url: String) -> AnyPublisher<(PrepareResponse, ProcessResponse), GlideSDKError> {
        logger.info("Invoke flow succeeded with status: \(invokeResponse.status)")
        logger.info("Starting process flow with session key: \(invokeResponse.session_key)")
        
        return repository.executeProcess(url: url, sessionKey: invokeResponse.session_key)
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
    
}


