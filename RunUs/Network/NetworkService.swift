//
//  NetworkService.swift
//  RunUs
//
//  Created by Ryeong on 7/23/24.
//

import Foundation
import Combine

class NetworkService {
    static let shared = NetworkService()
    
    private init() { }
    
    func request<T: Decodable>(_ endpoint: NetworkEndpoint) -> AnyPublisher<T, NetworkError> {
        guard let url = configureURL(endpoint) else {
            return Fail<T, NetworkError>(error: NetworkError.request)
                .eraseToAnyPublisher()
        }
        let request = configureRequest(url: url, endpoint)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { _ in NetworkError.request }
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.parse }
            .eraseToAnyPublisher()
    }
    
    private func configureURL(_ endpoint: NetworkEndpoint) -> URL? {
        guard let baseURL = endpoint.baseURL else { return nil }
        let url = baseURL.appendingPathComponent(endpoint.path)
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil}
        components.queryItems = endpoint.parameters
        
        return components.url
    }
    
    private func configureRequest(url: URL, _ endpoint: NetworkEndpoint) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let header = endpoint.header {
            for (key,value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = endpoint.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        return request
    }
    
    func request<T: Decodable>(_ endpoint: NetworkEndpoint) async throws -> T {
        guard let url = configureURL(endpoint) else {
            throw NetworkError.request
        }
        
        let request = configureRequest(url: url, endpoint)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodeData = try JSONDecoder().decode(T.self, from: data)
            return decodeData
        } catch {
            throw NetworkError.parse
        }
    }
}

