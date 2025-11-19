//
//  user_agent_provider.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

import Foundation
import UIKit

protocol UserAgentProvider {
    func getUserAgent() -> String
}

class DefaultUserAgentProvider: UserAgentProvider {
    func getUserAgent() -> String {
        let device = UIDevice.current
        let systemVersion = device.systemVersion
        let deviceModel = device.model
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        
        return "GlideSwiftSDK/\(appVersion) (\(buildVersion)) iOS/\(systemVersion) \(deviceModel)"
    }
}
