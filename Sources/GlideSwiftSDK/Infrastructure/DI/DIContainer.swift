//
//  DIContainer.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 23/11/2025.
//

import Foundation

final class DIContainer {
    
    // MARK: - Configuration
    private let sdkConfig: GlideConfiguration
    
    // MARK: - Providers
    private lazy var apiRequestProvider: ApiRequestProvider = {
        return DefaultApiRequestProvider()
    }()
    
    private lazy var userAgentProvider: UserAgentProvider = {
        return DefaultUserAgentProvider()
    }()
    
    // MARK: - Use Cases
    private lazy var prepareFlow: PrepareFlow = {
        return PrepareFlow(
            apiRequestProvider: apiRequestProvider,
            userAgentProvider: userAgentProvider
        )
    }()
    
    private lazy var invokeFlow: InvokeFlow = {
        return InvokeFlow(apiRequestProvider: apiRequestProvider)
    }()
    
    private lazy var processFlow: ProcessFlow = {
        return ProcessFlow(apiRequestProvider: apiRequestProvider)
    }()
    
    // MARK: - Repository
    lazy var repository: Repository = {
        return GlideRepository(
            prepareFlow: prepareFlow,
            invokeFlow: invokeFlow,
            processFlow: processFlow
        )
    }()
    
    // MARK: - Initialization
    init(sdkConfig: GlideConfiguration) {
        self.sdkConfig = sdkConfig
    }
    
    func getConfig() -> GlideConfiguration {
        return sdkConfig
    }
}
