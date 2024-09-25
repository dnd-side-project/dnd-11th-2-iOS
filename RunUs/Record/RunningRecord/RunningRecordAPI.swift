//
//  RunningRecordAPI.swift
//  RunUs
//
//  Created by seungyooooong on 9/25/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var runningRecordAPI: RunningRecordAPI {
        get { self[RunningRecordAPIKey.self] }
        set { self[RunningRecordAPIKey.self]  = newValue }
    }
}

struct RunningRecordAPIKey: DependencyKey {
    static let liveValue: RunningRecordAPI = RunningRecordAPILive()
    static var previewValue: RunningRecordAPI = RunningRecordAPIPreview()
}

protocol RunningRecordAPI {
    func getMonthly(year: Int, month: Int) async throws -> RunningRecordMonthlyResponseModel
    func getDaily(date: String) async throws -> RunningRecordDailyResponseModel
}

final class RunningRecordAPILive: RunningRecordAPI {
    func getMonthly(year: Int, month: Int) async throws -> RunningRecordMonthlyResponseModel {
        try await ServerNetwork.shared.request(.getMonthly(year: year, month: month))
    }
    
    func getDaily(date: String) async throws -> RunningRecordDailyResponseModel {
        try await ServerNetwork.shared.request(.getDaily(date))
    }
}

final class RunningRecordAPIPreview: RunningRecordAPI {
    func getMonthly(year: Int, month: Int) async throws -> RunningRecordMonthlyResponseModel {
        return RunningRecordMonthlyResponseModel(days: ["2024-09-17"])
    }
    
    func getDaily(date: String) async throws -> RunningRecordDailyResponseModel {
        return RunningRecordDailyResponseModel(records: [RunningRecordDaily(startLocation: "서울특별시 강남구", distanceMeter: 999, averagePace: "9'99\"", calorie: 99, duration: "99:99")])
    }
}
