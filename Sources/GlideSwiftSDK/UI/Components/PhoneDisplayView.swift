//
//  PhoneDisplayView.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 03/12/2025.
//

#if canImport(SwiftUI)
import SwiftUI

/// Static phone number display component
struct PhoneDisplayView: View {
    let phoneNumber: String
    let localizationService: LocalizationService
    
    var body: some View {
        VStack(spacing: 8) {
            Text(localizationService.string(for: .verifyingNumberLabel))
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(phoneNumber)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

#if DEBUG
struct PhoneDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneDisplayView(
            phoneNumber: "+14152654845",
            localizationService: DefaultLocalizationService()
        )
        .padding()
    }
}
#endif
#endif
