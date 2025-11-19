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
    
    init(prepareFlow: PrepareFlow, invokeFlow: InvokeFlow) {
        self.prepareFlow = prepareFlow
        self.invokeFlow = invokeFlow
    }
    
    func executePrepare(url: String) -> AnyPublisher<PrepareResponse, SDKError> {
        return prepareFlow.execute(url: url)
    }
    
    func executeInvoke(url: String) -> AnyPublisher<InvokeResponse, SDKError> {
        return invokeFlow.execute(url: url)
    }
}
