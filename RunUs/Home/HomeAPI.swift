//
//  HomeAPI.swift
//  RunUs
//
//  Created by seungyooooong on 8/28/24.
//

import Foundation

protocol HomeAPI {
    func getWeathers(weatherParameters: WeatherParametersModel) async throws -> WeatherResponseModel
    func getChallenges() async throws -> [TodayChallenge]
    func getMonthlySummary() async throws -> MonthlySummaryResponseModel
}

final class HomeAPILive: HomeAPI {
    func getWeathers(weatherParameters: WeatherParametersModel) async throws -> WeatherResponseModel {
        let result: WeatherResponseModel = try await ServerNetwork.shared.request(.getWeathers(longitude: weatherParameters.longitude, latitude: weatherParameters.latitude))
        return result
    }
    func getChallenges() async throws -> [TodayChallenge] {
        let result: [TodayChallenge] = try await ServerNetwork.shared.request(.getChallenges)
        return result
    }
    func getMonthlySummary() async throws -> MonthlySummaryResponseModel {
        let result: MonthlySummaryResponseModel = try await ServerNetwork.shared.request(.getMonthlySummary)
        return result
    }
}

final class HomeAPIPreview: HomeAPI {
    func getWeathers(weatherParameters: WeatherParametersModel) async throws -> WeatherResponseModel {
        return WeatherResponseModel("비내리는 날", "빗물이 고인 곳이 많을 수 있으니 달리며 미끄러지지 않도록 조심하세요", "", 28, 20, 30)
    }
    func getChallenges() async throws -> [TodayChallenge] {
        return [TodayChallenge(challengeId: 0, title: "어제보다 5분 더 뛰기", expectedTime: "5분", icon: ""), TodayChallenge(challengeId: 1, title: "어제보다 5분 더 뛰기", expectedTime: "5분", icon: "")]
    }
    func getMonthlySummary() async throws -> MonthlySummaryResponseModel {
        return MonthlySummaryResponseModel("7월", "32km", "Level 2", "18km")
    }
}
