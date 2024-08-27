//
//  HomeAPI.swift
//  RunUs
//
//  Created by seungyooooong on 8/28/24.
//

import Foundation

protocol HomeAPI {
    func getWeathers() async throws -> WeatherResponseModel
    func getChallenges() async throws -> [TodayChallenge]
    func getRunningRecord() async throws -> RunningRecordResponseModel
}

final class HomeAPILive: HomeAPI {  // TODO: API 나오면 연동
    func getWeathers() async throws -> WeatherResponseModel {
        return WeatherResponseModel()
    }
    func getChallenges() async throws -> [TodayChallenge] {
        return []
    }
    func getRunningRecord() async throws -> RunningRecordResponseModel {
        return RunningRecordResponseModel()
    }
}

final class HomeAPIPreview: HomeAPI {
    func getWeathers() async throws -> WeatherResponseModel {
        return WeatherResponseModel("", "비내리는 날", "빗물이 고인 곳이 많을 수 있으니 달리며 미끄러지지 않도록 조심하세요", 28, 30, 20)
    }
    func getChallenges() async throws -> [TodayChallenge] {
        return [TodayChallenge(id: 0, imageUrl: "", title: "어제보다 5분 더 뛰기", estimatedMinute: 5, isSelected: false), TodayChallenge(id: 0, imageUrl: "", title: "어제보다 5분 더 뛰기", estimatedMinute: 5, isSelected: false)]
    }
    func getRunningRecord() async throws -> RunningRecordResponseModel {
        return RunningRecordResponseModel(7, "32km", "Level 2", "18km")
    }
}
