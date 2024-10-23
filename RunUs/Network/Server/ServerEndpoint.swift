//
//  ServerEndpoint.swift
//  RunUs
//
//  Created by Ryeong on 7/24/24.
//

import Foundation

enum ServerEndpoint: NetworkEndpoint {
    case getServerVersion(version: String)
    case signUp(signUpRequest: SignUpRequestModel)
    case signIn(signInRequest: SignInRequestModel)
    case withdraw(withdrawRequest: WithdrawRequestModel)
    case getProfiles
    case getBadges
    case postRunningRecord(result: RunningResult)
    case getRunningRecord(runningRecordId: Int)
    case getMonthly(year: Int, month: Int)
    case getDaily(String)
    case getChallenges
    case getWeathers(longitude: Double, latitude: Double)
    case getMonthlySummary
    case getWeeklySummary(summaryType: String)
    case getCourses
    case getBadgeLists
    
    var baseURL: URL? { URL(string: "https://api.runus.site") }
    
    enum APIversion {
        static let v1 = "/api/v1"
    }
    
    var path: String {
        switch self {
        case .getServerVersion:
            return APIversion.v1 + "/servers/versions"
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
        case .postRunningRecord:
            return APIversion.v1 + "/running-records"
        case .getRunningRecord(let runningRecordId):
            return APIversion.v1 + "/running-records/\(runningRecordId)"
        case .getMonthly:
            return APIversion.v1 + "/running-records/monthly-dates"
        case .getDaily:
            return APIversion.v1 + "/running-records/daily"
        case .getChallenges:
            return APIversion.v1 + "/challenges"
        case .getWeathers:
            return APIversion.v1 + "/weathers"
        case .getMonthlySummary:
            return APIversion.v1 + "/running-records/monthly-summary"
        case .getWeeklySummary:
            return APIversion.v1 + "/running-records/weekly-summary"
        case .getCourses:
            return APIversion.v1 + "/scale/courses"
        case .getBadgeLists:
            return APIversion.v1 + "/badges/me/lists"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .getServerVersion,
                .getProfiles,
                .getBadges,
                .getRunningRecord,
                .getMonthly,
                .getDaily,
                .getChallenges,
                .getWeathers,
                .getMonthlySummary,
                .getWeeklySummary,
                .getCourses,
                .getBadgeLists:
            return .get
        case .signUp, .signIn, .withdraw, .postRunningRecord:
            return .post
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .getMonthly(let year, let month):
            return [.init(name: "year", value: String(year)),
                    .init(name: "month", value: String(month))]
        case .getDaily(let date):
            return [.init(name: "date", value: date)]
        case .getServerVersion(let version):
            return[.init(name: "version", value: version)]
        case .getWeathers(let longitude, let latitude):
            return [.init(name: "longitude", value: String(longitude)),
                    .init(name: "latitude", value: String(latitude))]
        case .getWeeklySummary(let summaryType):
            return [.init(name: "summaryType", value: summaryType)]
        default:
            return nil
        }
    }
    var header: [String : String]? {
        switch self {
        case .signUp, .signIn:
            return ["Content-Type": "application/json"]
        case .getProfiles,
                .getBadges,
                .getRunningRecord,
                .getMonthly,
                .getDaily,
                .getChallenges,
                .getWeathers,
                .getMonthlySummary,
                .getWeeklySummary,
                .getCourses,
                .getBadgeLists:
            guard let accessToken: String = UserDefaultManager.accessToken else {
                return nil
            }
            return ["Authorization": "Bearer " + accessToken]
        case .withdraw, .postRunningRecord:
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
        case .postRunningRecord(let result):
            return result
        default:
            return nil
        }
    }
}
