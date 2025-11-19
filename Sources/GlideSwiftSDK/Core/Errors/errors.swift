//
//  errors.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

public enum GlideSDKError: Error {
    case statusCode(Int, String)
    case unknown(Error)
    case sdkNotInitialized
    case configurationMissing
    
    var localizedDescription: String {
        switch self {
        case .statusCode(let code, let desctiption):
            return "request failed with status code: \(code). description: \(desctiption)"
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        case .sdkNotInitialized:
            return "Glide SDK has not been initialized. Please call Glide.configure(prepareUrl:proccessUrl:) before using the SDK."
        case .configurationMissing:
            return "Glide SDK configuration is missing. Please call Glide.configure(prepareUrl:proccessUrl:) before using the SDK."
        }
    }
}

struct APIError: Codable {
    let error: String
    let error_description: String
}
