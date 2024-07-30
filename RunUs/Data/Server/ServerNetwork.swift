//
//  ServerNetwork.swift
//  RunUs
//
//  Created by Ryeong on 7/24/24.
//

import Foundation
import Combine

class ServerNetwork {
    static let shared = ServerNetwork()
    
    private init() { }
    
    func request<T: Decodable>(_ endpoint: ServerEndpoint) -> AnyPublisher<T, NetworkError> {
        NetworkService.shared.request(endpoint)
            .tryMap { (response: ServerResponse<T>) in
                if let data = response.data, response.success {
                    return data
                } else if let error = response.error {
                    throw NetworkError.server(code: error.statusCode)
                } else {
                    throw NetworkError.parse
                }
            }
            .mapError{ error -> NetworkError in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
    
    func request(_ endpoint: ServerEndpoint) -> AnyPublisher<Void, NetworkError> {
        NetworkService.shared.request(endpoint)
            .tryMap { (response: ServerResponse<Bool>) in
                if response.success {
                    return
                } else if let error = response.error {
                    throw NetworkError.server(code: error.statusCode)
                } else {
                    throw NetworkError.parse
                }
            }
            .mapError{ error -> NetworkError in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
