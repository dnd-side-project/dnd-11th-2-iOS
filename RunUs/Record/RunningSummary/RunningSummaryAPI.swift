//
//  RunningSummaryAPI.swift
//  RunUs
//
//  Created by seungyooooong on 10/10/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var runningSummaryAPI: RunningSummaryAPI {
        get { self[RunningSummaryAPIKey.self] }
        set { self[RunningSummaryAPIKey.self]  = newValue }
    }
}

struct RunningSummaryAPIKey: DependencyKey {
    static let liveValue: RunningSummaryAPI = RunningSummaryAPILive()
    static var previewValue: RunningSummaryAPI = RunningSummaryAPIPreview()
}

protocol RunningSummaryAPI {
    func getWeeklySummary(summaryType: String) async throws -> WeeklySummaryResponseModel
}

final class RunningSummaryAPILive: RunningSummaryAPI {
    func getWeeklySummary(summaryType: String) async throws -> WeeklySummaryResponseModel {
        try await ServerNetwork.shared.request(.getWeeklySummary(summaryType: summaryType))
    }
}

final class RunningSummaryAPIPreview: RunningSummaryAPI {
    func getWeeklySummary(summaryType: String) async throws -> WeeklySummaryResponseModel {
        return WeeklySummaryResponseModel(
            weeklyDate: "2024.09.09 ~ 2024.09.15",
            weeklyValues: [
                ChartData(day: "월", rating: 0),
                ChartData(day: "화", rating: 0),
                ChartData(day: "수", rating: 2),
                ChartData(day: "목", rating: 5),
                ChartData(day: "금", rating: 0),
                ChartData(day: "토", rating: 3),
                ChartData(day: "일", rating: 1)
                ],
            lastWeekAvgValue: 3
        )
    }
}

