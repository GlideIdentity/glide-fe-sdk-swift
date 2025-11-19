//
//  invoke_response.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

import Foundation

enum InvokeStatus: String, Codable {
    case pending
    case completed
    case failed
}

struct InvokeResponse: Codable {
    let session_key: String
    let status: InvokeStatus
    let `protocol`: String
    let created_at: String
    let last_updated: String
}
