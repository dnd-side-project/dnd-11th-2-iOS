//
//  MyRecordAPI.swift
//  RunUs
//
//  Created by seungyooooong on 8/20/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var myRecordAPI: MyRecordAPI {
        get { self[MyRecordAPIKey.self] }
        set { self[MyRecordAPIKey.self] = newValue }
    }
}

struct MyRecordAPIKey: DependencyKey {
    static var liveValue: MyRecordAPI = MyRecordAPILive()
    static var previewValue: MyRecordAPI = MyRecordAPIPreview()
}

protocol MyRecordAPI {
    func withdraw(withdrawRequest: WithdrawRequestModel) async throws
}

final class MyRecordAPILive: MyRecordAPI {
    func withdraw(withdrawRequest: WithdrawRequestModel) async throws {
        try await ServerNetwork.shared.request(.withdraw(withdrawRequest: withdrawRequest))
    }
}

final class MyRecordAPIPreview: MyRecordAPI {
    func withdraw(withdrawRequest: WithdrawRequestModel) async throws {}
}
