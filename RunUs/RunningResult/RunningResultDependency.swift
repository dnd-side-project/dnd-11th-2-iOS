//
//  RunningResultDependency.swift
//  RunUs
//
//  Created by Ryeong on 9/7/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var runningRecordAPI: RunningResultAPI {
        get { self[RunningRecordAPIKey.self] }
        set { self[RunningRecordAPIKey.self]  = newValue }
    }
}

struct RunningRecordAPIKey: DependencyKey {
    static let liveValue: RunningResultAPI = RunningResultAPILive()
}


protocol RunningResultAPI {
    func postRunningRecord(result: RunningResult) async throws -> RunningRecord
}

final class RunningResultAPILive: RunningResultAPI {
    func postRunningRecord(result: RunningResult) async throws -> RunningRecord {
        try await ServerNetwork.shared.request(.postRunningRecord(result: result))
    }
}
