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
    case signUp(signUpRequest: SignUpRequestModel)
    case signIn(signInRequest: SignInRequestModel)
    case withdraw(withdrawRequest: WithdrawRequestModel)
    case getProfiles
    case getBadges
    case getChallenges
    case getWeathers(longitude: Double, latitude: Double)
    case getMonthlySummary
    
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
        case .signUp:
            return APIversion.v1 + "/auth/oauth/sign-up"
        case .signIn:
            return APIversion.v1 + "/auth/oauth/sign-in"
        case .withdraw:
            return APIversion.v1 + "/auth/oauth/withdraw"
        case .getProfiles:
            return APIversion.v1 + "/members/profiles/me"
        case .getBadges:
            return APIversion.v1 + "/badges/me"
        case .getChallenges:
            return APIversion.v1 + "/challenges"
        case .getWeathers:
            return APIversion.v1 + "/weathers"
        case .getMonthlySummary:
            return APIversion.v1 + "/running-records/monthly-summary"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .testRequest, .testResponse, .testError, .testHeader, .getProfiles, .getBadges, .getChallenges, .getWeathers, .getMonthlySummary:
            return .get
        case .signUp, .signIn, .withdraw:
            return .post
        }
    }
    var parameters: [URLQueryItem]? {
        switch self {
        case .testRequest(let string):
            return [.init(name: "input", value: string)]
        case .getWeathers(let longitude, let latitude):
            return [.init(name: "longitude", value: String(longitude)), .init(name: "latitude", value: String(latitude))]
        default:
            return nil
        }
    }
    var header: [String : String]? {
        switch self {
        case .signUp, .signIn:
            return ["Content-Type": "application/json"]
        case .testHeader, .getProfiles, .getBadges, .getChallenges, .getWeathers, .getMonthlySummary:
            guard let accessToken: String = UserDefaultManager.accessToken else {
                return nil
            }
            return ["Authorization": "Bearer " + accessToken]
        case .withdraw:
            guard let accessToken: String = UserDefaultManager.accessToken else {
                return nil
            }
            return ["Content-Type": "application/json", "Authorization": "Bearer " + accessToken]
        default:
            return nil
        }
    }
    var body: Encodable? {
        switch self {
        case .signUp(let signUpRequest):
            return signUpRequest
        case .signIn(let signInRequest):
            return signInRequest
        case .withdraw(let withdrawRequest):
            return withdrawRequest
        default:
            return nil
        }
    }
}
