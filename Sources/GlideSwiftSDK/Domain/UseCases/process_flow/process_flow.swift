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
    
    func execute(url: String, sessionKey: String) -> AnyPublisher<ProcessResponse, GlideSDKError> {
        guard let requestUrl = URL(string: url) else {
            logger.error("Invalid process URL: \(url)")
            return Fail(error: GlideSDKError.unknown(NSError(domain: "Invalid URL", code: -1)))
                .eraseToAnyPublisher()
        }
        
        let processRequest = ProcessRequest(
            session: ProcessRequest.Session(
                session_key: sessionKey,
                protocol_type: "link"
            ),
            credential: sessionKey,
            use_case: "VerifyPhoneNumber"
        )
        
        guard let requestBody = try? JSONEncoder().encode(processRequest) else {
            logger.error("Failed to encode process request")
            return Fail(error: GlideSDKError.unknown(NSError(domain: "Encoding error", code: -1)))
                .eraseToAnyPublisher()
        }
        
        logger.info("Executing process flow with URL: \(url)")
        
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
