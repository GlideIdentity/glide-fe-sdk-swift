//
//  prepare_flow.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

import Foundation
import Combine

class PrepareFlow {
    private let apiRequestProvider: ApiRequestProvider
    
    init(apiRequestProvider: ApiRequestProvider) {
        self.apiRequestProvider = apiRequestProvider
    }
    
    // Execute with PrepareRequest (without phone number)
    func execute(url: String, request: PrepareRequest) -> AnyPublisher<PrepareResponse, GlideSDKError> {
        return executeRequest(url: url, request: request)
    }
    
    // Execute with PrepareRequestWithPhone
    func execute(url: String, request: PrepareRequestWithPhone) -> AnyPublisher<PrepareResponse, GlideSDKError> {
        return executeRequest(url: url, request: request)
    }
    
    // Private helper for PrepareRequest
    private func executeRequest(url: String, request: PrepareRequest) -> AnyPublisher<PrepareResponse, GlideSDKError> {
        guard let requestUrl = URL(string: url) else {
            logger.error("Invalid prepare URL: \(url)")
            return Fail(error: GlideSDKError.unknown(NSError(domain: "Invalid URL", code: -1)))
                .eraseToAnyPublisher()
        }
        
        guard let requestBody = try? JSONEncoder().encode(request) else {
            logger.error("Failed to encode prepare request")
            return Fail(error: GlideSDKError.unknown(NSError(domain: "Encoding error", code: -1)))
                .eraseToAnyPublisher()
        }
        
        logger.info("Executing prepare flow without phone number")
        
        return apiRequestProvider.request(
            url: requestUrl,
            method: .POST,
            headers: nil,
            body: requestBody
        )
        .subscribe(on: DispatchQueue.global(qos: .background))
        .eraseToAnyPublisher()
    }
    
    // Private helper for PrepareRequestWithPhone
    private func executeRequest(url: String, request: PrepareRequestWithPhone) -> AnyPublisher<PrepareResponse, GlideSDKError> {
        guard let requestUrl = URL(string: url) else {
            logger.error("Invalid prepare URL: \(url)")
            return Fail(error: GlideSDKError.unknown(NSError(domain: "Invalid URL", code: -1)))
                .eraseToAnyPublisher()
        }
        
        guard let requestBody = try? JSONEncoder().encode(request) else {
            logger.error("Failed to encode prepare request")
            return Fail(error: GlideSDKError.unknown(NSError(domain: "Encoding error", code: -1)))
                .eraseToAnyPublisher()
        }
        
        logger.info("Executing prepare flow with phone number")
        
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
