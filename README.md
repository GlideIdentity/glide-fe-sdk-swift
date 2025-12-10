# GlideSwiftSDK

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/GlideIdentity/glide-fe-sdk-swift.git")
]
```

## Usage

```swift
import GlideSwiftSDK

// Configure
Glide.configure(
    prepareUrl: "https://your-api.com/prepare", 
    processUrl: "https://your-api.com/process"
)

// Verify with phone number
Glide.instance.verify("+14152654845") { result in
    switch result {
    case .success(let data):
        print("Success! Code: \(data.code)")
    case .failure(let error):
        print("Error: \(error)")
    }
}

// Or verify without phone number
Glide.instance.verify { result in
    // Handle result
}
```

## Requirements

- iOS 15.0+
- Swift 5.9+

