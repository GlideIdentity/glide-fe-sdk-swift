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
    private let userAgentProvider: UserAgentProvider
    
    init(apiRequestProvider: ApiRequestProvider, userAgentProvider: UserAgentProvider = DefaultUserAgentProvider()) {
        self.apiRequestProvider = apiRequestProvider
        self.userAgentProvider = userAgentProvider
    }
    
    func execute(url: String) -> AnyPublisher<PrepareResponse, GlideSDKError> {
        guard let requestUrl = URL(string: url) else {
            logger.error("Invalid prepare URL: \(url)")
            return Fail(error: GlideSDKError.unknown(NSError(domain: "Invalid URL", code: -1)))
                .eraseToAnyPublisher()
        }
        
        let prepareRequest = PrepareRequest(
            use_case: "VerifyPhoneNumber",
            phone_number: "+14152654845",
            nonce: "PYVzSoVZZb_1LeEW9gFYYChjgNPqNXQr9elBJlu56Cs",
            id: "ios-1763548919441-aw4y2m485",
            consent_data: PrepareRequest.ConsentData(
                consent_text: "I consent to verify my phone number from the SIM card",
                policy_link: "https://example.com/privacy-policy",
                policy_text: "Privacy Policy"
            ),
            client_info: PrepareRequest.ClientInfo(
                user_agent: userAgentProvider.getUserAgent(),
                platform: "iOS"
            )
        )
        
        guard let requestBody = try? JSONEncoder().encode(prepareRequest) else {
            logger.error("Failed to encode prepare request")
            return Fail(error: GlideSDKError.unknown(NSError(domain: "Encoding error", code: -1)))
                .eraseToAnyPublisher()
        }
        
        logger.info("Executing prepare flow with URL: \(url)")
        
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
