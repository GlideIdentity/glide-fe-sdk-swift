//
//  ResultView.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 03/12/2025.
//

#if canImport(SwiftUI)
import SwiftUI

/// Result display component showing success or error
struct ResultView: View {
    let code: String?
    let state: String?
    let errorMessage: String?
    let isSuccess: Bool
    let localizationService: LocalizationService
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(isSuccess ? .green : .red)
            
            Text(isSuccess ? localizationService.string(for: .successTitle) : localizationService.string(for: .failureTitle))
                .font(.headline)
                .foregroundColor(.primary)
            
            if isSuccess, let code = code, let state = state {
                Text(String(format: localizationService.string(for: .successMessage), code, state))
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            } else if !isSuccess, let errorMessage = errorMessage {
                Text(String(format: localizationService.string(for: .failureMessage), errorMessage))
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background((isSuccess ? Color.green : Color.red).opacity(0.1))
        .cornerRadius(12)
        .transition(.scale.combined(with: .opacity))
    }
}

#if DEBUG
struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        let localizationService = DefaultLocalizationService()
        VStack(spacing: 20) {
            ResultView(
                code: "123456",
                state: "verified",
                errorMessage: nil,
                isSuccess: true,
                localizationService: localizationService
            )
            
            ResultView(
                code: nil,
                state: nil,
                errorMessage: "Invalid phone number",
                isSuccess: false,
                localizationService: localizationService
            )
        }
        .padding()
    }
}
#endif
#endif
