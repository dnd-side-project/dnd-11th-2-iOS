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
    case testHeader
    case appleLogin(appleLoginRequest: AuthLoginRequestModel)
    case getProfiles
    case getBadges
    
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
        case .testHeader:
            return APIversion.v1 + "/examples/headers"
        case .appleLogin:
            return APIversion.v1 + "/auth/oauth"
        case .getProfiles:
            return APIversion.v1 + "/members/profiles/me"
        case .getBadges:
            return APIversion.v1 + "/badges/me"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .testRequest, .testResponse, .testError, .testHeader, .getProfiles, .getBadges:
            return .get
        case .appleLogin:
            return .post
        }
    }
    var parameters: [URLQueryItem]? {
        switch self {
        case .testRequest(let string):
            return [.init(name: "input", value: string)]
        default:
            return nil
        }
    }
    var header: [String : String]? {
        switch self {
        case .appleLogin:
            return ["Content-Type": "application/json"]
        case .testHeader, .getProfiles, .getBadges:
            guard let accessToken: String = UserDefaultManager.accessToken else {
                return nil
            }
            return ["Authorization": "Bearer " + accessToken]
        default:
            return nil
        }
    }
    var body: Encodable? {
        switch self {
        case .appleLogin(let appleLoginRequest):
            return appleLoginRequest
        default:
            return nil
        }
    }
}
