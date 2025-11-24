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

You can optionally specify a log level to control the verbosity of SDK logs:

```swift
Glide.configure(
    prepareUrl: "https://your-api.com/prepare", 
    processUrl: "https://your-api.com/process",
    logLevel: .debug  // Options: .none, .error, .info, .verbose, .debug
)
```

Third, start the authentication flow. You have two options:

#### Option 1: Verify with Phone Number

Provide a phone number to verify:

```swift
Glide.instance.verify("+14152654845") { result in
    switch result {
    case .success(let data):
        print("Success! Code: \(data.code), State: \(data.state)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}
```

#### Option 2: Verify without Phone Number

Let the SDK get the phone number from the device:

```swift
Glide.instance.verify { result in
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
        Glide.instance.verify(phoneNumber) { result in
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

### Verification Methods

The SDK provides two verification methods using method overloading:

1. **`verify(_:completion:)`**: Use this when you want to verify a specific phone number provided by the user.
   - Use Case: `VerifyPhoneNumber`
   - Requires: Phone number in E.164 format

2. **`verify(completion:)`**: Use this when you want the SDK to automatically get the phone number from the device.
   - Use Case: `GetPhoneNumber`
   - Requires: No phone number parameter

### Configuration

The SDK needs to be configured with two URLs:
- **prepareUrl**: The endpoint for initiating the verification flow
- **processUrl**: The endpoint for processing the verification

#### Log Levels

The SDK supports the following log levels (default is `.info`):
- **`.none`**: No logging
- **`.error`**: Only error messages
- **`.info`**: Informational messages and errors (default)
- **`.verbose`**: Detailed information including info and errors
- **`.debug`**: All log messages including debug information (only in DEBUG builds)

Example with custom log level:
```swift
Glide.configure(
    prepareUrl: "https://your-api.com/prepare",
    processUrl: "https://your-api.com/process",
    logLevel: .error  // Only show errors
)
```

### Phone Number Format

Phone numbers should be provided in E.164 format (e.g., `+14152654845`).
