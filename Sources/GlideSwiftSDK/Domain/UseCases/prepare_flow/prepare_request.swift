//
//  prepare_request.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

import Foundation

struct PrepareRequest: Codable {
    let use_case: String
    let phone_number: String
    let nonce: String
    let id: String
    let consent_data: ConsentData
    let client_info: ClientInfo
    
    struct ConsentData: Codable {
        let consent_text: String
        let policy_link: String
        let policy_text: String
    }
    
    struct ClientInfo: Codable {
        let user_agent: String
        let platform: String
    }
}
