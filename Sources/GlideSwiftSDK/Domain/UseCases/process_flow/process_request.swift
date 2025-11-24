//
//  process_request.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

import Foundation

// Shared data structures
struct Session: Codable {
    let session_key: String
    let protocol_type: String
    let metadata: Metadata
}

struct Metadata: Codable {
    let use_case: String
}

// Base process request without phone number
struct ProcessRequest: Codable {
    let session: Session
    let credential: String
    let use_case: String
}

// Process request with phone number
struct ProcessRequestWithPhone: Codable {
    let session: Session
    let credential: String
    let use_case: String
    let phone_number: String
}
