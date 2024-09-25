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
    func getProfiles() async throws -> ProfileResponseModel
    func getBadges() async throws -> [Badge]
    func withdraw(withdrawRequest: WithdrawRequestModel) async throws
}

final class MyRecordAPILive: MyRecordAPI {
    func getProfiles() async throws -> ProfileResponseModel {
        let result: ProfileResponseModel = try await ServerNetwork.shared.request(.getProfiles)
        return result
    }
    func getBadges() async throws -> [Badge] {
        let result: BadgesResponseModel = try await ServerNetwork.shared.request(.getBadges)
        return result.badges
    }
    func withdraw(withdrawRequest: WithdrawRequestModel) async throws {
        try await ServerNetwork.shared.request(.withdraw(withdrawRequest: withdrawRequest))
    }
}

final class MyRecordAPIPreview: MyRecordAPI {
    func getProfiles() async throws -> ProfileResponseModel {
        return ProfileResponseModel("", "Level 1", "20Km", "Level 2", "5Km")
    }
    func getBadges() async throws -> [Badge] {
        return []
    }
    func withdraw(withdrawRequest: WithdrawRequestModel) async throws {}
}
