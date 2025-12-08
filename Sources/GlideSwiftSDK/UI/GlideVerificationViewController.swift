//
//  GlideVerificationViewController.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 01/12/2025.
//

#if canImport(UIKit) && canImport(SwiftUI)
import UIKit
import SwiftUI

// MARK: - UIKit ViewController

/// UIKit wrapper for Glide verification
///
/// Example:
/// ```swift
/// let vc = GlideVerificationViewController(
///     headerText: "My App",
///     headerImage: UIImage(named: "logo")
/// ) { result in
///     switch result {
///     case .success(let data):
///         print("Code: \(data.code), State: \(data.state)")
///     case .failure(let error):
///         print("Error: \(error)")
///     }
/// }
/// present(vc, animated: true)
/// ```
public class GlideVerificationViewController: UIViewController {
    
    private let headerText: String?
    private let headerImage: UIImage?
    private let onCompletion: ((Result<(code: String, state: String), GlideSDKError>) -> Void)?
    
    public init(
        headerText: String? = nil,
        headerImage: UIImage? = nil,
        completion: ((Result<(code: String, state: String), GlideSDKError>) -> Void)? = nil
    ) {
        self.headerText = headerText
        self.headerImage = headerImage
        self.onCompletion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        embedSwiftUIView()
    }
    
    private func embedSwiftUIView() {
        let swiftUIView = GlideVerificationView(
            headerText: headerText,
            headerImage: headerImage,
            onCompletion: { [weak self] in self?.onCompletion?($0) },
            onDismiss: { [weak self] in self?.dismiss(animated: true) }
        )
        
        let hostingController = UIHostingController(rootView: swiftUIView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
}

// MARK: - SwiftUI View

/// SwiftUI view for Glide verification
///
/// Example:
/// ```swift
/// GlideVerificationView(
///     headerText: "My App",
///     headerImage: UIImage(named: "logo")
/// ) { result in
///     switch result {
///     case .success(let data):
///         print("Code: \(data.code), State: \(data.state)")
///     case .failure(let error):
///         print("Error: \(error)")
///     }
/// } onDismiss: {
///     // Handle dismiss
/// }
/// ```
public struct GlideVerificationView: View {
    
    private let headerText: String?
    private let headerImage: UIImage?
    private let onCompletion: ((Result<(code: String, state: String), GlideSDKError>) -> Void)?
    private let onDismiss: (() -> Void)?
    
    public init(
        headerText: String? = nil,
        headerImage: UIImage? = nil,
        onCompletion: ((Result<(code: String, state: String), GlideSDKError>) -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.headerText = headerText
        self.headerImage = headerImage
        self.onCompletion = onCompletion
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HeaderView(text: headerText, image: headerImage)
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { onDismiss?() }
                }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct GlideVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GlideVerificationView(headerText: "My App")
            GlideVerificationView()
        }
    }
}
#endif
#endif
