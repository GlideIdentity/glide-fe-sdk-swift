//
//  ProcessRequestBuilder.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 24/11/2025.
//

import Foundation

protocol ProcessRequestBuilder {
    func buildRequest(sessionKey: String, useCase: VerificationUseCase) -> ProcessRequest
    func buildRequestWithPhone(sessionKey: String, phoneNumber: String, useCase: VerificationUseCase) -> ProcessRequestWithPhone
}

class DefaultProcessRequestBuilder: ProcessRequestBuilder {
    
    func buildRequest(sessionKey: String, useCase: VerificationUseCase) -> ProcessRequest {
        let session = Session(
            session_key: sessionKey,
            protocol_type: "link",
            metadata: Metadata(
                use_case: useCase.rawValue
            )
        )
        
        return ProcessRequest(
            session: session,
            credential: sessionKey,
            use_case: useCase.rawValue
        )
    }
    
    func buildRequestWithPhone(sessionKey: String, phoneNumber: String, useCase: VerificationUseCase) -> ProcessRequestWithPhone {
        let session = Session(
            session_key: sessionKey,
            protocol_type: "link",
            metadata: Metadata(
                use_case: useCase.rawValue
            )
        )
        
        return ProcessRequestWithPhone(
            session: session,
            credential: sessionKey,
            use_case: useCase.rawValue,
            phone_number: phoneNumber
        )
    }
}
