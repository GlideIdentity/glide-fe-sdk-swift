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
    
    init(prepareFlow: PrepareFlow, invokeFlow: InvokeFlow, processFlow: ProcessFlow) {
        self.prepareFlow = prepareFlow
        self.invokeFlow = invokeFlow
        self.processFlow = processFlow
    }
    
    func executePrepare(url: String, phoneNumber: String) -> AnyPublisher<PrepareResponse, GlideSDKError> {
        return prepareFlow.execute(url: url, phoneNumber: phoneNumber)
    }
    
    func executeInvoke(url: String) -> AnyPublisher<InvokeResponse, GlideSDKError> {
        return invokeFlow.execute(url: url)
    }
    
    func executeProcess(url: String, sessionKey: String, phoneNumber: String) -> AnyPublisher<ProcessResponse, GlideSDKError> {
        return processFlow.execute(url: url, sessionKey: sessionKey, phoneNumber: phoneNumber)
    }
}
