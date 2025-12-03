//
//  VerifyButton.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 03/12/2025.
//

#if canImport(SwiftUI)
import SwiftUI

/// Verification action button with loading state
struct VerifyButton: View {
    let isVerifying: Bool
    let isDisabled: Bool
    let action: () -> Void
    let localizationService: LocalizationService
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if isVerifying {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    Text(localizationService.string(for: .verifyingButton))
                        .fontWeight(.semibold)
                } else {
                    Image(systemName: "checkmark.shield.fill")
                    Text(localizationService.string(for: .verifyButton))
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isDisabled ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(isDisabled)
    }
}

#if DEBUG
struct VerifyButton_Previews: PreviewProvider {
    static var previews: some View {
        let localizationService = DefaultLocalizationService()
        VStack(spacing: 20) {
            VerifyButton(
                isVerifying: false, 
                isDisabled: false, 
                action: {},
                localizationService: localizationService
            )
            VerifyButton(
                isVerifying: true, 
                isDisabled: true, 
                action: {},
                localizationService: localizationService
            )
            VerifyButton(
                isVerifying: false, 
                isDisabled: true, 
                action: {},
                localizationService: localizationService
            )
        }
        .padding()
    }
}
#endif
#endif
