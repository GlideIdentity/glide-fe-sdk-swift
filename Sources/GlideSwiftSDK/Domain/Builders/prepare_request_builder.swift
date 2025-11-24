//
//  PrepareRequestBuilder.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 24/11/2025.
//

import Foundation

protocol PrepareRequestBuilder {
    func buildRequest(useCase: VerificationUseCase) -> PrepareRequest
    func buildRequestWithPhone(phoneNumber: String, useCase: VerificationUseCase) -> PrepareRequestWithPhone
}

class DefaultPrepareRequestBuilder: PrepareRequestBuilder {
    private let userAgentProvider: UserAgentProvider
    
    init(userAgentProvider: UserAgentProvider) {
        self.userAgentProvider = userAgentProvider
    }
    
    func buildRequest(useCase: VerificationUseCase) -> PrepareRequest {
        let consentData = ConsentData(
            consent_text: "I consent to verify my phone number from the SIM card",
            policy_link: "https://example.com/privacy-policy",
            policy_text: "Privacy Policy"
        )
        
        let clientInfo = ClientInfo(
            user_agent: userAgentProvider.getUserAgent(),
            platform: "iOS"
        )
        
        return PrepareRequest(
            use_case: useCase.rawValue,
            nonce: "PYVzSoVZZb_1LeEW9gFYYChjgNPqNXQr9elBJlu56Cs",
            id: "ios-1763548919441-aw4y2m485",
            consent_data: consentData,
            client_info: clientInfo
        )
    }
    
    func buildRequestWithPhone(phoneNumber: String, useCase: VerificationUseCase) -> PrepareRequestWithPhone {
        let consentData = ConsentData(
            consent_text: "I consent to verify my phone number from the SIM card",
            policy_link: "https://example.com/privacy-policy",
            policy_text: "Privacy Policy"
        )
        
        let clientInfo = ClientInfo(
            user_agent: userAgentProvider.getUserAgent(),
            platform: "iOS"
        )
        
        return PrepareRequestWithPhone(
            use_case: useCase.rawValue,
            phone_number: phoneNumber,
            nonce: "PYVzSoVZZb_1LeEW9gFYYChjgNPqNXQr9elBJlu56Cs",
            id: "ios-1763548919441-aw4y2m485",
            consent_data: consentData,
            client_info: clientInfo
        )
    }
}
