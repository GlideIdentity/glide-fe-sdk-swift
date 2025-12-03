//
//  GlideVerificationViewController.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 01/12/2025.
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(SwiftUI)
import SwiftUI
#endif

// MARK: - UIKit ViewController

#if canImport(UIKit) && canImport(SwiftUI)
/// UIKit wrapper for Glide phone verification
///
/// Example:
/// ```swift
/// let vc = GlideVerificationViewController(phoneNumber: "+1234567890") { result in
///     print("Result: \(result)")
/// }
/// present(vc, animated: true)
/// ```
public class GlideVerificationViewController: UIViewController {
    
    private let phoneNumber: String?
    private let onCompletion: ((Result<(code: String, state: String), GlideSDKError>) -> Void)?
    
    public init(
        phoneNumber: String? = nil,
        completion: ((Result<(code: String, state: String), GlideSDKError>) -> Void)? = nil
    ) {
        self.phoneNumber = phoneNumber
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
        // Get localization service from DI container
        let localizationService = Glide.instance.getLocalizationService()
        
        let swiftUIView = GlideVerificationView(
            phoneNumber: phoneNumber,
            onCompletion: { [weak self] result in
                self?.onCompletion?(result)
            },
            onDismiss: { [weak self] in
                self?.dismiss(animated: true)
            },
            localizationService: localizationService
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
#endif

// MARK: - SwiftUI View

#if canImport(SwiftUI)
/// SwiftUI view for Glide phone verification
///
/// Example:
/// ```swift
/// GlideVerificationView(phoneNumber: "+1234567890") { result in
///     print("Result: \(result)")
/// } onDismiss: {
///     // Handle dismiss
/// }
/// ```
public struct GlideVerificationView: View {
    
    @State private var phoneNumber: String
    @State private var isVerifying: Bool = false
    @State private var resultCode: String? = nil
    @State private var resultState: String? = nil
    @State private var resultErrorMessage: String? = nil
    @State private var isSuccess: Bool = false
    @State private var showResult: Bool = false
    
    private let initialPhoneNumber: String?
    private let onCompletion: ((Result<(code: String, state: String), GlideSDKError>) -> Void)?
    private let onDismiss: (() -> Void)?
    private let localizationService: LocalizationService
    
    public init(
        phoneNumber: String? = nil,
        onCompletion: ((Result<(code: String, state: String), GlideSDKError>) -> Void)? = nil,
        onDismiss: (() -> Void)? = nil,
        localizationService: LocalizationService = DefaultLocalizationService()
    ) {
        self.initialPhoneNumber = phoneNumber
        self._phoneNumber = State(initialValue: phoneNumber ?? "")
        self.onCompletion = onCompletion
        self.onDismiss = onDismiss
        self.localizationService = localizationService
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    HeaderView(localizationService: localizationService)
                    
                    phoneInputSection
                    
                    VerifyButton(
                        isVerifying: isVerifying,
                        isDisabled: isVerifying || (initialPhoneNumber == nil && phoneNumber.isEmpty),
                        action: startVerification,
                        localizationService: localizationService
                    )
                    
                    if showResult {
                        ResultView(
                            code: resultCode,
                            state: resultState,
                            errorMessage: resultErrorMessage,
                            isSuccess: isSuccess,
                            localizationService: localizationService
                        )
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localizationService.string(for: .closeButton)) { onDismiss?() }
                }
            }
        }
    }
    
    private var phoneInputSection: some View {
        Group {
            if initialPhoneNumber == nil {
                PhoneInputView(
                    phoneNumber: $phoneNumber, 
                    isDisabled: isVerifying,
                    localizationService: localizationService
                )
            } else {
                PhoneDisplayView(
                    phoneNumber: phoneNumber,
                    localizationService: localizationService
                )
            }
        }
    }
    
    private func startVerification() {
        isVerifying = true
        showResult = false
        
        if let initialPhoneNumber = initialPhoneNumber {
            Glide.instance.verify(initialPhoneNumber, completion: handleResult)
        } else if !phoneNumber.isEmpty {
            Glide.instance.verify(phoneNumber, completion: handleResult)
        } else {
            Glide.instance.verify(completion: handleResult)
        }
    }
    
    private func handleResult(_ result: Result<(code: String, state: String), GlideSDKError>) {
        DispatchQueue.main.async {
            isVerifying = false
            
            withAnimation {
                showResult = true
            }
            
            switch result {
            case .success(let data):
                isSuccess = true
                resultCode = data.code
                resultState = data.state
                resultErrorMessage = nil
                
            case .failure(let error):
                isSuccess = false
                resultCode = nil
                resultState = nil
                resultErrorMessage = error.localizedDescription
            }
            
            onCompletion?(result)
        }
    }
}

#if DEBUG
struct GlideVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GlideVerificationView()
                .previewDisplayName("No Phone Number")
            
            GlideVerificationView(phoneNumber: "+14152654845")
                .previewDisplayName("With Phone Number")
            
            GlideVerificationView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
#endif
#endif
