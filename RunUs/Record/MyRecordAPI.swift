//
//  MyRecordAPI.swift
//  RunUs
//
//  Created by seungyooooong on 8/20/24.
//

import Foundation

protocol MyRecordAPI {
    func getProfiles() async throws -> ProfileResponseModel
    func getBadges() async throws -> [Badge]
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
}

final class MyRecordAPIPreview: MyRecordAPI {
    func getProfiles() async throws -> ProfileResponseModel {
        return ProfileResponseModel("", "20Km", "Level 2", "5Km")
    }
    func getBadges() async throws -> [Badge] {
        return []
    }
}
