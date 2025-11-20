# GlideSwiftSDK

## Introduction

`GlideSwiftSDK` is our SDK for integrating with our systems

## Installation

### Cocoapods

[Cocoapods](https://cocoapods.org/#install) is a dependency manager for Swift projects. To use GlideSwiftSDK with CocoaPods, add it in your `Podfile`.

```ruby
pod 'GlideSwiftSDK'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. To use GlideSwiftSDK with Swift Package Manger, add it to `dependencies` in your `Package.swift`

```swift
dependencies: [
    .package(url: "https://github.com/GlideIdentity/glide-fe-sdk-swift.git")
]
```

## Usage

Firstly, import `GlideSwiftSDK`.

```swift
import GlideSwiftSDK
```

Second, configure the SDK with your prepare and process URLs. This is recommended in `application(_:didFinishLaunchingWithOptions:)` in `AppDelegate.swift` or in your app's initialization code.

```swift
Glide.configure(prepareUrl: "https://your-api.com/prepare", processUrl: "https://your-api.com/process")
```

Third, start the authentication flow by providing a phone number.

```swift
Glide.instance.start(phoneNumber: "+14152654845") { result in
    switch result {
    case .success(let data):
        print("Success! Code: \(data.code), State: \(data.state)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}
```

### Example with SwiftUI

```swift
import SwiftUI
import GlideSwiftSDK

struct ContentView: View {
    @State private var phoneNumber = ""
    @State private var resultMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Phone Number (e.g., +14152654845)", text: $phoneNumber)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.phonePad)
            
            Button("Start Verification") {
                startGlideSDK()
            }
            .disabled(phoneNumber.isEmpty)
            
            if !resultMessage.isEmpty {
                Text(resultMessage)
            }
        }
        .padding()
    }
    
    private func startGlideSDK() {
        Glide.instance.start(phoneNumber: phoneNumber) { result in
            switch result {
            case .success(let data):
                resultMessage = "Success! Code: \(data.code)"
            case .failure(let error):
                resultMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
}
```

### Configuration

The SDK needs to be configured with two URLs:
- **prepareUrl**: The endpoint for initiating the verification flow
- **processUrl**: The endpoint for processing the verification

### Phone Number Format

Phone numbers should be provided in E.164 format (e.g., `+14152654845`).
