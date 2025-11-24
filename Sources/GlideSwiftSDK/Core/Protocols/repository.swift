//
//  Repository.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

import Foundation
import Combine

protocol Repository {
    func executePrepare(url: String, phoneNumber: String?, useCase: VerificationUseCase) -> AnyPublisher<PrepareResponse, GlideSDKError>
    func executeInvoke(url: String) -> AnyPublisher<InvokeResponse, GlideSDKError>
    func executeProcess(url: String, sessionKey: String, phoneNumber: String?, useCase: VerificationUseCase) -> AnyPublisher<ProcessResponse, GlideSDKError>
}

