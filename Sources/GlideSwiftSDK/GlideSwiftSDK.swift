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
        Glide.instance = Glide(repository: GlideRepository(prepareFlow: prepareFlow, invokeFlow: invokeFlow))
        Glide.instance.sdkConfig = GlideConfiguration(prepareUrl: prepareUrl, proccessUel: proccessUrl)
    }
    
    init(repository : Repository) {
        self.repository = repository
    }
    
    public func start(completion: @escaping ((code: String, state: String)) -> Void) {
        guard Glide.instance != nil else {
            logger.error("Glide SDK has not been initialized. Please call Glide.configure(prepareUrl:proccessUrl:) before using the SDK.")
            return
        }
        
        guard let config = sdkConfig else {
            logger.error("Glide SDK configuration is missing. Please call Glide.configure(prepareUrl:proccessUrl:) before using the SDK.")
            return
        }
        
        logger.info("Starting Glide SDK prepare flow")
        
        repository.executePrepare(url: config.prepareUrl)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .flatMap { [weak self] prepareResponse -> AnyPublisher<(PrepareResponse, InvokeResponse), SDKError> in
                guard let self = self else {
                    return Fail(error: SDKError.unknown(NSError(domain: "Self deallocated", code: -1)))
                        .eraseToAnyPublisher()
                }
                
                logger.info("Prepare flow succeeded with session key: \(prepareResponse.session.session_key)")
                logger.info("Starting invoke flow with status URL: \(prepareResponse.data.status_url)")
                
                return self.repository.executeInvoke(url: prepareResponse.data.status_url)
                    .map { invokeResponse in (prepareResponse, invokeResponse) }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    logger.error("Flow failed: \(error.localizedDescription)")
                case .finished:
                    logger.info("All flows completed successfully")
                }
            }, receiveValue: { prepareResponse, invokeResponse in
                logger.info("Invoke flow succeeded with status: \(invokeResponse.status)")
                completion((code: prepareResponse.session.session_key, state: prepareResponse.session.nonce))
            })
            .store(in: &cancellables)
    }
    
}


