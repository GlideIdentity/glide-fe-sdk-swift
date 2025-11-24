//
//  process_flow.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

import Foundation
import Combine

class ProcessFlow {
    private let apiRequestProvider: ApiRequestProvider
    
    init(apiRequestProvider: ApiRequestProvider) {
        self.apiRequestProvider = apiRequestProvider
    }
    
    // Execute with ProcessRequest (without phone number)
    func execute(url: String, request: ProcessRequest) -> AnyPublisher<ProcessResponse, GlideSDKError> {
        return executeRequest(url: url, request: request)
    }
    
    // Execute with ProcessRequestWithPhone
    func execute(url: String, request: ProcessRequestWithPhone) -> AnyPublisher<ProcessResponse, GlideSDKError> {
        return executeRequest(url: url, request: request)
    }
    
    // Private helper for ProcessRequest
    private func executeRequest(url: String, request: ProcessRequest) -> AnyPublisher<ProcessResponse, GlideSDKError> {
        guard let requestUrl = URL(string: url) else {
            logger.error("Invalid process URL: \(url)")
            return Fail(error: GlideSDKError.unknown(NSError(domain: "Invalid URL", code: -1)))
                .eraseToAnyPublisher()
        }
        
        guard let requestBody = try? JSONEncoder().encode(request) else {
            logger.error("Failed to encode process request")
            return Fail(error: GlideSDKError.unknown(NSError(domain: "Encoding error", code: -1)))
                .eraseToAnyPublisher()
        }
        
        logger.info("Executing process flow without phone number")
        
        return apiRequestProvider.request(
            url: requestUrl,
            method: .POST,
            headers: nil,
            body: requestBody
        )
        .subscribe(on: DispatchQueue.global(qos: .background))
        .eraseToAnyPublisher()
    }
    
    // Private helper for ProcessRequestWithPhone
    private func executeRequest(url: String, request: ProcessRequestWithPhone) -> AnyPublisher<ProcessResponse, GlideSDKError> {
        guard let requestUrl = URL(string: url) else {
            logger.error("Invalid process URL: \(url)")
            return Fail(error: GlideSDKError.unknown(NSError(domain: "Invalid URL", code: -1)))
                .eraseToAnyPublisher()
        }
        
        guard let requestBody = try? JSONEncoder().encode(request) else {
            logger.error("Failed to encode process request")
            return Fail(error: GlideSDKError.unknown(NSError(domain: "Encoding error", code: -1)))
                .eraseToAnyPublisher()
        }
        
        logger.info("Executing process flow with phone number")
        
        return apiRequestProvider.request(
            url: requestUrl,
            method: .POST,
            headers: nil,
            body: requestBody
        )
        .subscribe(on: DispatchQueue.global(qos: .background))
        .eraseToAnyPublisher()
    }
}
