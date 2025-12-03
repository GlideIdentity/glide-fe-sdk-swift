//
//  PhoneInputView.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 03/12/2025.
//

#if canImport(SwiftUI)
import SwiftUI

/// Phone number input field component
struct PhoneInputView: View {
    @Binding var phoneNumber: String
    let isDisabled: Bool
    let localizationService: LocalizationService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(localizationService.string(for: .phoneNumberLabel))
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.gray)
                
                TextField(localizationService.string(for: .phoneNumberPlaceholder), text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
                    .autocapitalization(.none)
                    .disabled(isDisabled)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            Text(localizationService.string(for: .phoneNumberFormat))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#if DEBUG
struct PhoneInputView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneInputView(
            phoneNumber: .constant("+14152654845"), 
            isDisabled: false,
            localizationService: DefaultLocalizationService()
        )
        .padding()
    }
}
#endif
#endif
