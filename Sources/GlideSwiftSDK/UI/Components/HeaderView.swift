//
//  HeaderView.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 03/12/2025.
//

#if canImport(SwiftUI)
import SwiftUI

/// Header view displaying custom image and text
struct HeaderView: View {
    let text: String?
    let image: UIImage?
    
    var body: some View {
        VStack(spacing: 16) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200, maxHeight: 120)
            } else {
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
            }
            
            Text(text ?? "Glide")
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
}

#if DEBUG
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            HeaderView(text: nil, image: nil)
            HeaderView(text: "Custom App", image: nil)
        }
    }
}
#endif
#endif
