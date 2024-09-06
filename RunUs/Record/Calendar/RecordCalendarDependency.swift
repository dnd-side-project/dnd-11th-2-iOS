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