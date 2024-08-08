//
//  Endpoint.swift
//  RunUs
//
//  Created by Ryeong on 7/23/24.
//

import Foundation

protocol NetworkEndpoint {
    var baseURL: URL? { get }
    var path: String { get }
    var method: NetworkMethod { get }
    var parameters: [URLQueryItem]? { get }
    var header: [String: String]? { get }
    var body: Encodable? { get }
}

enum NetworkMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}
