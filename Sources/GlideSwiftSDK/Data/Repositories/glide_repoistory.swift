//
//  glide_repoistory.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

import Foundation
import Combine

class GlideRepository : Repository {
    
    let prepareFlow: PrepareFlow!
    let invokeFlow: InvokeFlow!
    let processFlow: ProcessFlow!
    private let prepareRequestBuilder: PrepareRequestBuilder
    private let processRequestBuilder: ProcessRequestBuilder
    
    init(prepareFlow: PrepareFlow, 
         invokeFlow: InvokeFlow, 
         processFlow: ProcessFlow,
         prepareRequestBuilder: PrepareRequestBuilder,
         processRequestBuilder: ProcessRequestBuilder) {
        self.prepareFlow = prepareFlow
        self.invokeFlow = invokeFlow
        self.processFlow = processFlow
        self.prepareRequestBuilder = prepareRequestBuilder
        self.processRequestBuilder = processRequestBuilder
    }
    
    func executePrepare(url: String, phoneNumber: String?, useCase: VerificationUseCase) -> AnyPublisher<PrepareResponse, GlideSDKError> {
        if let phoneNumber = phoneNumber {
            let request = prepareRequestBuilder.buildRequestWithPhone(phoneNumber: phoneNumber, useCase: useCase)
            return prepareFlow.execute(url: url, request: request)
        } else {
            let request = prepareRequestBuilder.buildRequest(useCase: useCase)
            return prepareFlow.execute(url: url, request: request)
        }
    }
    
    func executeInvoke(url: String) -> AnyPublisher<InvokeResponse, GlideSDKError> {
        return invokeFlow.execute(url: url)
    }
    
    func executeProcess(url: String, sessionKey: String, phoneNumber: String?, useCase: VerificationUseCase) -> AnyPublisher<ProcessResponse, GlideSDKError> {
        if let phoneNumber = phoneNumber {
            let request = processRequestBuilder.buildRequestWithPhone(sessionKey: sessionKey, phoneNumber: phoneNumber, useCase: useCase)
            return processFlow.execute(url: url, request: request)
        } else {
            let request = processRequestBuilder.buildRequest(sessionKey: sessionKey, useCase: useCase)
            return processFlow.execute(url: url, request: request)
        }
    }
}
