//
//  RunningResultAPI.swift
//  RunUs
//
//  Created by Ryeong on 9/7/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var runningResultAPI: RunningResultAPI {
        get { self[RunningResultAPIKey.self] }
        set { self[RunningResultAPIKey.self]  = newValue }
    }
}

struct RunningResultAPIKey: DependencyKey {
    static let liveValue: RunningResultAPI = RunningResultAPILive()
}


protocol RunningResultAPI {
    func postRunningRecord(result: RunningResult) async throws -> RunningRecordResponseModel
}

final class RunningResultAPILive: RunningResultAPI {
    func postRunningRecord(result: RunningResult) async throws -> RunningRecordResponseModel {
        try await ServerNetwork.shared.request(.postRunningRecord(result: result))
    }
}
