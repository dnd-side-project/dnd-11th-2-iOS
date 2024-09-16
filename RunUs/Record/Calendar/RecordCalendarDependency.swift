//
//  RecordCalendarDependency.swift
//  RunUs
//
//  Created by Ryeong on 9/1/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var recordCalendarAPI: RecordCalendarAPI {
        get { self[RecordCalendarAPIKey.self] }
        set { self[RecordCalendarAPIKey.self]  = newValue }
    }
}

struct RecordCalendarAPIKey: DependencyKey {
    static let liveValue: RecordCalendarAPI = RecordCalendarAPILive()
    static var previewValue: RecordCalendarAPI = RecordCalendarAPIPreview()
}


protocol RecordCalendarAPI {
    func getMonthly(year: Int, month: Int) async throws -> RunningMonthlyRecord
    func getDaily(date: String) async throws -> RunningRecordResponse
}

final class RecordCalendarAPILive: RecordCalendarAPI {
    func getMonthly(year: Int, month: Int) async throws -> RunningMonthlyRecord {
        try await ServerNetwork.shared.request(.getMonthly(year: year, month: month))
    }
    
    func getDaily(date: String) async throws -> RunningRecordResponse {
        try await ServerNetwork.shared.request(.getDaily(date))
    }
}

final class RecordCalendarAPIPreview: RecordCalendarAPI {
    func getMonthly(year: Int, month: Int) async throws -> RunningMonthlyRecord {
        return RunningMonthlyRecord(days: ["2024-09-17"])
    }
    
    func getDaily(date: String) async throws -> RunningRecordResponse {
        return RunningRecordResponse(records: [RunningRecord(startLocation: "서울특별시 강남구", distanceMeter: 999, averagePace: "9'99\"", calorie: 99, duration: "99:99")])
    }
}
