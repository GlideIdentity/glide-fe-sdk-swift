//
//  LocalizationService.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 03/12/2025.
//

import Foundation

/// Service for managing SDK localization
public protocol LocalizationService {
    func string(for key: LocalizationKey) -> String
}

/// Default implementation of LocalizationService
public class DefaultLocalizationService: LocalizationService {
    
    private let bundle: Bundle
    private let tableName: String
    
    public init(bundle: Bundle? = nil, tableName: String = "Localizable") {
        // Use SDK bundle, fallback to module bundle if available
        if let providedBundle = bundle {
            self.bundle = providedBundle
        } else if let sdkBundle = Bundle(identifier: "com.glide.GlideSwiftSDK") {
            self.bundle = sdkBundle
        } else {
            self.bundle = Bundle.main
        }
        self.tableName = tableName
    }
    
    public func string(for key: LocalizationKey) -> String {
        return NSLocalizedString(key.rawValue, tableName: tableName, bundle: bundle, comment: key.comment)
    }
}

/// Keys for localized strings in the SDK
public enum LocalizationKey: String {
    
    // MARK: - Verification Screen
    
    case verificationTitle = "verification.title"
    case verificationSubtitle = "verification.subtitle"
    case phoneNumberLabel = "verification.phoneNumber.label"
    case phoneNumberPlaceholder = "verification.phoneNumber.placeholder"
    case phoneNumberFormat = "verification.phoneNumber.format"
    case verifyingNumberLabel = "verification.verifyingNumber.label"
    case verifyButton = "verification.button.verify"
    case verifyingButton = "verification.button.verifying"
    case closeButton = "verification.button.close"
    
    // MARK: - Results
    
    case successTitle = "result.success.title"
    case successMessage = "result.success.message"
    case failureTitle = "result.failure.title"
    case failureMessage = "result.failure.message"
    
    // MARK: - Errors
    
    case errorConfigurationNotSet = "error.configurationNotSet"
    case errorNetworkFailure = "error.networkFailure"
    case errorInvalidResponse = "error.invalidResponse"
    case errorUnknown = "error.unknown"
    
    // MARK: - Comments
    
    var comment: String {
        switch self {
        case .verificationTitle:
            return "Title for the phone verification screen"
        case .verificationSubtitle:
            return "Subtitle explaining the verification process"
        case .phoneNumberLabel:
            return "Label for phone number input field"
        case .phoneNumberPlaceholder:
            return "Placeholder text for phone number input"
        case .phoneNumberFormat:
            return "Format hint for phone number"
        case .verifyingNumberLabel:
            return "Label shown when verifying a specific number"
        case .verifyButton:
            return "Text for verify button"
        case .verifyingButton:
            return "Text shown during verification"
        case .closeButton:
            return "Text for close button"
        case .successTitle:
            return "Title for successful verification"
        case .successMessage:
            return "Message template for successful verification"
        case .failureTitle:
            return "Title for failed verification"
        case .failureMessage:
            return "Message template for failed verification"
        case .errorConfigurationNotSet:
            return "Error when SDK is not configured"
        case .errorNetworkFailure:
            return "Error for network failures"
        case .errorInvalidResponse:
            return "Error for invalid server responses"
        case .errorUnknown:
            return "Generic error message"
        }
    }
}
