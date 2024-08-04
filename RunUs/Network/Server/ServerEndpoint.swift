//
//  ServerEndpoint.swift
//  RunUs
//
//  Created by Ryeong on 7/24/24.
//

import Foundation

enum ServerEndpoint: NetworkEndpoint {
    case testRequest(string: String)
    case testResponse
    case testError
    
    var baseURL: URL? { URL(string: "https://api.runus.site") }
    
    enum APIversion {
        static let v1 = "/api/v1"
    }
    
    var path: String {
        switch self {
        case .testRequest:
            return APIversion.v1 + "/examples/input"
        case .testResponse:
            return APIversion.v1 + "/examples/empty"
        case .testError:
            return APIversion.v1 + "/examples/errors"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .testRequest, .testResponse, .testError:
            return .get
        }
    }
    var parameters: [URLQueryItem]? {
        switch self {
        case .testRequest(let string):
            return [.init(name: "input", value: string)]
        case .testResponse, .testError:
            return nil
        }
    }
    var header: [String : String]? { nil }
    var body: Data? { nil }
}
