//
//  MainAPI.swift
//  RunUs
//
//  Created by seungyooooong on 10/3/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var mainAPI: MainAPI {
        get { self[MainAPIKey.self] }
        set { self[MainAPIKey.self] = newValue }
    }
}

struct MainAPIKey: DependencyKey {
    static var liveValue: MainAPI = MainAPILive()
    static var previewValue: MainAPI = MainAPIPreview()
}

protocol MainAPI {
    func getChallenges() async throws -> [TodayChallenge]
    func getWeathers(weatherParameters: WeatherParametersModel) async throws -> WeatherResponseModel
    func getMonthlySummary() async throws -> MonthlySummaryResponseModel
    func getProfiles() async throws -> ProfileResponseModel
    func getBadges() async throws -> [Badge]
}

final class MainAPILive: MainAPI {
    func getChallenges() async throws -> [TodayChallenge] {
        let result: [TodayChallenge] = try await ServerNetwork.shared.request(.getChallenges)
        return result
    }
    func getWeathers(weatherParameters: WeatherParametersModel) async throws -> WeatherResponseModel {
        let result: WeatherResponseModel = try await ServerNetwork.shared.request(.getWeathers(longitude: weatherParameters.longitude, latitude: weatherParameters.latitude))
        return result
    }
    func getMonthlySummary() async throws -> MonthlySummaryResponseModel {
        let result: MonthlySummaryResponseModel = try await ServerNetwork.shared.request(.getMonthlySummary)
        return result
    }
    func getProfiles() async throws -> ProfileResponseModel {
        let result: ProfileResponseModel = try await ServerNetwork.shared.request(.getProfiles)
        return result
    }
    func getBadges() async throws -> [Badge] {
        let result: BadgesResponseModel = try await ServerNetwork.shared.request(.getBadges)
        return result.badges
    }
}

final class MainAPIPreview: MainAPI {
    func getChallenges() async throws -> [TodayChallenge] {
        return [TodayChallenge(id: 0, title: "어제보다 5분 더 뛰기", expectedTime: "5분", icon: ""), TodayChallenge(id: 1, title: "어제보다 5분 더 뛰기", expectedTime: "5분", icon: "")]
    }
    func getWeathers(weatherParameters: WeatherParametersModel) async throws -> WeatherResponseModel {
        return WeatherResponseModel("비내리는 날", "빗물이 고인 곳이 많을 수 있으니 달리며 미끄러지지 않도록 조심하세요", "", 28, 20, 30)
    }
    func getMonthlySummary() async throws -> MonthlySummaryResponseModel {
        return MonthlySummaryResponseModel("7월", "32km", "Level 2", "18km")
    }
    func getProfiles() async throws -> ProfileResponseModel {
        return ProfileResponseModel("", "Level 1", "20Km", "Level 2", "5Km")
    }
    func getBadges() async throws -> [Badge] {
        return []
    }
}
