# Glide Verification UI Component

A ready-to-use phone verification UI that works seamlessly with both **SwiftUI** and **UIKit**.

## 📋 Overview

The Glide SDK provides two components that share the same SwiftUI implementation:

1. **`GlideVerificationView`** - Native SwiftUI view
2. **`GlideVerificationViewController`** - UIKit wrapper around the SwiftUI view

### How It Works

```
┌─────────────────────────────────────────┐
│   GlideVerificationViewController       │  ← UIKit wrapper
│   (UIViewController)                    │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │  UIHostingController              │ │  ← Bridge
│  │                                   │ │
│  │  ┌─────────────────────────────┐ │ │
│  │  │ GlideVerificationView       │ │ │  ← SwiftUI core
│  │  │ (SwiftUI View)              │ │ │
│  │  │                             │ │ │
│  │  │ • Phone input               │ │ │
│  │  │ • Verify button             │ │ │
│  │  │ • Loading state             │ │ │
│  │  │ • Result display            │ │ │
│  │  └─────────────────────────────┘ │ │
│  └───────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

**Key Concept**: One SwiftUI view powers both implementations. UIKit apps use `UIHostingController` to embed the SwiftUI view.

---

## 🎯 SwiftUI Usage

### Basic Usage

```swift
import SwiftUI
import GlideSwiftSDK

struct ContentView: View {
    @State private var showVerification = false
    
    var body: some View {
        Button("Verify Phone") {
            showVerification = true
        }
        .sheet(isPresented: $showVerification) {
            GlideVerificationView { result in
                // Handle completion
                switch result {
                case .success(let data):
                    print("✅ Code: \(data.code), State: \(data.state)")
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                }
            } onDismiss: {
                showVerification = false
            }
        }
    }
}
```

### With Pre-filled Phone Number

```swift
GlideVerificationView(phoneNumber: "+14152654845") { result in
    // Handle result
} onDismiss: {
    // Handle dismiss
}
```

### In Navigation Stack

```swift
NavigationStack {
    List {
        NavigationLink("Verify Phone") {
            GlideVerificationView()
        }
    }
}
```

### Full Screen Cover

```swift
.fullScreenCover(isPresented: $showVerification) {
    GlideVerificationView(phoneNumber: userPhoneNumber) { result in
        // Handle result
    } onDismiss: {
        showVerification = false
    }
}
```

---

## 📱 UIKit Usage

### Present Modally

```swift
import UIKit
import GlideSwiftSDK

class MyViewController: UIViewController {
    
    func showVerification() {
        // Create the view controller
        let verificationVC = GlideVerificationViewController { result in
            switch result {
            case .success(let data):
                print("✅ Code: \(data.code)")
                self.showSuccessAlert(code: data.code)
            case .failure(let error):
                print("❌ Error: \(error)")
                self.showErrorAlert(error: error)
            }
        }
        
        // Present modally
        verificationVC.modalPresentationStyle = .fullScreen
        present(verificationVC, animated: true)
    }
}
```

### With Phone Number

```swift
let verificationVC = GlideVerificationViewController(
    phoneNumber: "+14152654845"
) { result in
    // Handle result
}

present(verificationVC, animated: true)
```

### Push to Navigation Stack

```swift
let verificationVC = GlideVerificationViewController(phoneNumber: "+14152654845")
navigationController?.pushViewController(verificationVC, animated: true)
```

### As Page Sheet (iOS 15+)

```swift
let verificationVC = GlideVerificationViewController()
verificationVC.modalPresentationStyle = .pageSheet

if let sheet = verificationVC.sheetPresentationController {
    sheet.detents = [.medium(), .large()]
    sheet.prefersGrabberVisible = true
}

present(verificationVC, animated: true)
```

---

## 🎨 Features

| Feature | Description |
|---------|-------------|
| **📱 Dual Support** | Works with both SwiftUI and UIKit |
| **🔢 Flexible Input** | Accept phone number or let user enter it |
| **🤖 Auto-detect** | Can verify without phone number input |
| **⏳ Loading States** | Built-in loading indicators |
| **✅ Result Display** | Visual feedback for success/failure |
| **🎨 Customizable** | Standard SwiftUI/UIKit customization |
| **🌓 Dark Mode** | Automatic dark mode support |

---

## 🔧 Customization

### SwiftUI Customization

```swift
GlideVerificationView()
    .accentColor(.purple)           // Change accent color
    .preferredColorScheme(.dark)    // Force dark mode
```

### UIKit Customization

```swift
let verificationVC = GlideVerificationViewController()

// Customize presentation
verificationVC.modalPresentationStyle = .formSheet
verificationVC.modalTransitionStyle = .coverVertical

// Customize navigation bar (if in nav stack)
verificationVC.navigationItem.title = "Verify"
verificationVC.navigationItem.largeTitleDisplayMode = .never

present(verificationVC, animated: true)
```

---

## 🎭 Three Verification Modes

### Mode 1: With Phone Number (Pre-filled)

```swift
// SwiftUI
GlideVerificationView(phoneNumber: "+14152654845")

// UIKit
GlideVerificationViewController(phoneNumber: "+14152654845")
```

**Use Case**: You already have the user's phone number (from signup form, profile, etc.)

### Mode 2: Manual Input

```swift
// SwiftUI
GlideVerificationView()  // No phone number provided

// UIKit
GlideVerificationViewController()  // No phone number provided
```

**Use Case**: User needs to enter their phone number

### Mode 3: Auto-detect

```swift
// If user doesn't enter a phone number, SDK will auto-detect
// This happens automatically when verify button is tapped with empty input
```

**Use Case**: Device can provide phone number automatically

---

## 📊 Complete Example

### SwiftUI App

```swift
import SwiftUI
import GlideSwiftSDK

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var showVerification = false
    @State private var verificationResult: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Glide Verification Demo")
                .font(.title)
            
            Button("Start Verification") {
                showVerification = true
            }
            .buttonStyle(.borderedProminent)
            
            if !verificationResult.isEmpty {
                Text(verificationResult)
                    .foregroundColor(.green)
            }
        }
        .sheet(isPresented: $showVerification) {
            GlideVerificationView(phoneNumber: "+14152654845") { result in
                switch result {
                case .success(let data):
                    verificationResult = "Verified! Code: \(data.code)"
                case .failure(let error):
                    verificationResult = "Failed: \(error.localizedDescription)"
                }
                showVerification = false
            } onDismiss: {
                showVerification = false
            }
        }
    }
}
```

### UIKit App

```swift
import UIKit
import GlideSwiftSDK

class ViewController: UIViewController {
    
    private let verifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Verify Phone", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        verifyButton.addTarget(self, action: #selector(verifyTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(verifyButton)
        view.addSubview(resultLabel)
        
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verifyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            resultLabel.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func verifyTapped() {
        let verificationVC = GlideVerificationViewController(
            phoneNumber: "+14152654845"
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.resultLabel.text = "✅ Verified!\nCode: \(data.code)"
                    self?.resultLabel.textColor = .systemGreen
                case .failure(let error):
                    self?.resultLabel.text = "❌ Failed\n\(error.localizedDescription)"
                    self?.resultLabel.textColor = .systemRed
                }
            }
        }
        
        verificationVC.modalPresentationStyle = .fullScreen
        present(verificationVC, animated: true)
    }
}
```

---

## ❓ FAQ

### Q: Can I use this in a UIKit app?
**A:** Yes! Use `GlideVerificationViewController` - it wraps the SwiftUI view for UIKit.

### Q: Can I customize the UI colors?
**A:** Yes, use SwiftUI modifiers or UIKit appearance APIs.

### Q: Does it work on iPad?
**A:** Yes, it adapts automatically to different screen sizes.

### Q: Can I use it in a navigation stack?
**A:** Yes, both UIKit and SwiftUI navigation are supported.

### Q: What iOS version is required?
**A:** iOS 14.0+ (required for `UIHostingController` support)

---

## 🚀 Summary

**For SwiftUI apps**: Use `GlideVerificationView` directly

**For UIKit apps**: Use `GlideVerificationViewController` (which wraps the SwiftUI view)

**Both share the same UI and logic** - pick the one that matches your app's framework! 🎉
