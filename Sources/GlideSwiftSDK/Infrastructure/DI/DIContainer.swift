//
//  DIContainer.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 23/11/2025.
//

import Foundation

internal final class DIContainer {
    
    // MARK: - Configuration
    private let sdkConfig: GlideConfiguration
    
    // MARK: - Initialization
    init(sdkConfig: GlideConfiguration) {
        self.sdkConfig = sdkConfig
    }
    
    internal func getConfig() -> GlideConfiguration {
        return sdkConfig
    }
    
    // MARK: - Providers
    internal func provideApiRequestProvider() -> ApiRequestProvider {
        return DefaultApiRequestProvider()
    }
    
    internal func provideUserAgentProvider() -> UserAgentProvider {
        return DefaultUserAgentProvider()
    }
    
    internal func provideLocalizationService() -> LocalizationService {
        return DefaultLocalizationService()
    }
    
    // MARK: - Builders
    internal func providePrepareRequestBuilder() -> PrepareRequestBuilder {
        return DefaultPrepareRequestBuilder(userAgentProvider: provideUserAgentProvider())
    }
    
    internal func provideProcessRequestBuilder() -> ProcessRequestBuilder {
        return DefaultProcessRequestBuilder()
    }
    
    // MARK: - Use Cases
    internal func providePrepareFlow() -> PrepareFlow {
        return PrepareFlow(apiRequestProvider: provideApiRequestProvider())
    }
    
    internal func provideInvokeFlow() -> InvokeFlow {
        return InvokeFlow(apiRequestProvider: provideApiRequestProvider())
    }
    
    internal func provideProcessFlow() -> ProcessFlow {
        return ProcessFlow(apiRequestProvider: provideApiRequestProvider())
    }
    
    // MARK: - Repository
    internal func provideRepository() -> Repository {
        return GlideRepository(
            prepareFlow: providePrepareFlow(),
            invokeFlow: provideInvokeFlow(),
            processFlow: provideProcessFlow(),
            prepareRequestBuilder: providePrepareRequestBuilder(),
            processRequestBuilder: provideProcessRequestBuilder()
        )
    }
}
