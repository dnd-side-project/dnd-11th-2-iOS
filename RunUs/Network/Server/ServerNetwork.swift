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
                    throw NetworkError.server(error: error)
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
            .tryMap { (response: ServerResponse<EmptyData>) in
                if response.success {
                    return
                } else if let error = response.error {
                    throw NetworkError.server(error: error)
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
    
    func request<T: Decodable>(_ endpoint: ServerEndpoint) async throws -> T {
        LoadingManager.shared.startLoading()
        defer { LoadingManager.shared.stopLoading() }
        
        do {
            let response: ServerResponse<T> = try await NetworkService.shared.request(endpoint)
            
            if let data = response.data, response.success {
                return data
            } else if let error = response.error {
                throw NetworkError.server(error: error)
            } else {
                throw NetworkError.parse
            }
        } catch {
           throw mapError(error)
        }
    }
    
    func request(_ endpoint: ServerEndpoint) async throws -> Void {
        LoadingManager.shared.startLoading()
        defer { LoadingManager.shared.stopLoading() }
        
        do {
            let response: ServerResponse<EmptyData> = try await NetworkService.shared.request(endpoint)
            
            if response.success {
                return
            } else if let error = response.error {
                throw NetworkError.server(error: error)
            } else {
                throw NetworkError.unknown
            }
        } catch {
            throw mapError(error)
        }
    }
    
    private func mapError(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        } else {
            return NetworkError.unknown
        }
    }
}
