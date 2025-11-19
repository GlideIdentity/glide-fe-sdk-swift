//
//  invoke_flow.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

import Foundation
import Combine

class InvokeFlow {
    private let apiRequestProvider: ApiRequestProvider
    private let pollingInterval: TimeInterval = 3.0
    
    init(apiRequestProvider: ApiRequestProvider = DefaultApiRequestProvider()) {
        self.apiRequestProvider = apiRequestProvider
    }
    
    func execute(url: String) -> AnyPublisher<InvokeResponse, SDKError> {
        guard let requestUrl = URL(string: url) else {
            logger.error("Invalid invoke URL: \(url)")
            return Fail(error: SDKError.unknown(NSError(domain: "Invalid URL", code: -1)))
                .eraseToAnyPublisher()
        }
        
        logger.debug("Starting invoke flow polling")
        
        return startPolling(url: requestUrl)
    }
    
    private func startPolling(url: URL) -> AnyPublisher<InvokeResponse, SDKError> {
        Timer.publish(every: pollingInterval, on: RunLoop.main, in: .common)
            .autoconnect()
            .setFailureType(to: SDKError.self)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .flatMap { [weak self] _ -> AnyPublisher<InvokeResponse?, SDKError> in
                guard let self = self else {
                    return Just(nil).setFailureType(to: SDKError.self).eraseToAnyPublisher()
                }
                return self.makeRequest(url: url)
            }
            .compactMap { $0 }
            .first()
            .eraseToAnyPublisher()
    }
    
    private func makeRequest(url: URL) -> AnyPublisher<InvokeResponse?, SDKError> {
        apiRequestProvider.request(url: url, method: .GET, headers: nil, body: nil)
            .flatMap { [weak self] response -> AnyPublisher<InvokeResponse?, SDKError> in
                guard let self = self else {
                    return Just(nil).setFailureType(to: SDKError.self).eraseToAnyPublisher()
                }
                return self.handleResponse(response)
            }
            .eraseToAnyPublisher()
    }
    
    private func handleResponse(_ response: InvokeResponse) -> AnyPublisher<InvokeResponse?, SDKError> {
        logger.debug("Invoke status: \(response.status.rawValue)")
        
        switch response.status {
        case .completed:
            logger.info("Invoke completed successfully")
            return Just(response).setFailureType(to: SDKError.self).eraseToAnyPublisher()
            
        case .failed:
            logger.error("Invoke failed")
            return Fail(error: SDKError.statusCode(-1, "Invoke flow failed")).eraseToAnyPublisher()
            
        case .pending:
            logger.debug("Status pending, continuing to poll...")
            return Just(nil).setFailureType(to: SDKError.self).eraseToAnyPublisher()
        }
    }
}
