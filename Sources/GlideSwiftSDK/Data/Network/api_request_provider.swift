//
//  api_request_provider.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

import Foundation
import Combine

public enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH
}

protocol ApiRequestProvider {
    func request<T: Decodable>(url: URL, method: HTTPMethod, headers: [String: String]?, body: Data?) -> AnyPublisher<T, SDKError>
    func request(url: URL, method: HTTPMethod, headers: [String: String]?, body: Data?) -> AnyPublisher<Data, SDKError>
}

class DefaultApiRequestProvider: ApiRequestProvider {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func request<T: Decodable>(url: URL, method: HTTPMethod, headers: [String: String]? = nil, body: Data? = nil) -> AnyPublisher<T, SDKError> {
        execute(url: url, method: method, headers: headers, body: body)
            .tryMap { try JSONDecoder().decode(T.self, from: $0) }
            .mapError { SDKError.unknown($0) }
            .eraseToAnyPublisher()
    }
    
    public func request(url: URL, method: HTTPMethod, headers: [String: String]? = nil, body: Data? = nil) -> AnyPublisher<Data, SDKError> {
        execute(url: url, method: method, headers: headers, body: body)
    }
    
    // MARK: - Private
    
    private func execute(url: URL, method: HTTPMethod, headers: [String: String]?, body: Data?) -> AnyPublisher<Data, SDKError> {
        let request = buildRequest(url: url, method: method, headers: headers, body: body)
        logger.debug("\(method.rawValue) \(url.absoluteString)")
        
        return session.dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response in
                try self?.validateResponse(response, data: data) ?? data
            }
            .mapError { [weak self] error in
                self?.mapError(error) ?? SDKError.unknown(error)
            }
            .eraseToAnyPublisher()
    }
    
    private func buildRequest(url: URL, method: HTTPMethod, headers: [String: String]?, body: Data?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = body
        return request
    }
    
    private func validateResponse(_ response: URLResponse, data: Data) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SDKError.unknown(NSError(domain: "Invalid response", code: -1))
        }
        
        logger.debug("Status: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let message = parseErrorMessage(from: data)
            throw SDKError.statusCode(httpResponse.statusCode, message)
        }
        
        return data
    }
    
    private func parseErrorMessage(from data: Data) -> String {
        if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
            return apiError.error_description
        }
        return String(data: data, encoding: .utf8) ?? "Unknown error"
    }
    
    private func mapError(_ error: Error) -> SDKError {
        (error as? SDKError) ?? SDKError.unknown(error)
    }
}
