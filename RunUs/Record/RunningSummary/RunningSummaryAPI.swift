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
        return WeeklySummaryResponseModel(date: "2024.09.09 ~ 2024.09.15", weeklyValues: [0, 0, 2, 5, 0, 3, 1], lastWeekAvgValue: 3)
    }
}

