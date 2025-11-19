//
//  process_request.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

import Foundation

struct ProcessRequest: Codable {
    let session: Session
    let credential: String
    let use_case: String
    let phone_number: String

    struct Session: Codable {
        let session_key: String
        let protocol_type: String
        let metadata: Metadata
    }
    
    struct Metadata: Codable {
        let use_case: String
    }
}
