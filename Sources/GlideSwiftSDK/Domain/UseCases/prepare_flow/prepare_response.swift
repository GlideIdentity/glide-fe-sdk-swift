//
//  prepare_response.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

import Foundation

struct PrepareResponse: Codable {
    let authentication_strategy: String
    let session: Session
    let data: PrepareData
    
    struct Session: Codable {
        let session_key: String
        let nonce: String
        let enc_key: String
        let metadata: Metadata
        let protocol_type: String
        
        struct Metadata: Codable {
            let client_os: String
            let journey_strategy: String
            let prepare_complete_time: String
            let prepare_duration: String
            let prepare_start_time: String
        }
    }
    
    struct PrepareData: Codable {
        let url: String
        let return_url: String
        let status_url: String
    }
}
