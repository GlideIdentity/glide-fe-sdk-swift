//
//  HeaderView.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 03/12/2025.
//

#if canImport(SwiftUI)
import SwiftUI

/// Header view for verification screen
struct HeaderView: View {
    let localizationService: LocalizationService
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "phone.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text(localizationService.string(for: .verificationTitle))
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(localizationService.string(for: .verificationSubtitle))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
}

#if DEBUG
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(localizationService: DefaultLocalizationService())
    }
}
#endif
#endif
