//
//  RunAloneAPI.swift
//  RunUs
//
//  Created by Ryeong on 8/12/24.
//

import Foundation

protocol RunAloneAPI {
    func getTodayChallenge() async throws -> [TodayChallenge]
}

final class RunAloneAPIImplements: RunAloneAPI {
    func getTodayChallenge() async throws -> [TodayChallenge] {
        let result: [TodayChallenge] = try await ServerNetwork.shared.request(.getChallenges)
        return result
    }
}

final class RunAloneAPIMock: RunAloneAPI {
    func getTodayChallenge() async throws -> [TodayChallenge] {
        return [
            .init(challengeId: 0, title: "어제보다 500m더 뛰기", expectedTime: "12분", icon: "SampleImage", isSelected: false),
            .init(challengeId: 1, title: "저번보다 500m더 뛰기", expectedTime: "99999분", icon: "SampleImage", isSelected: false),
            .init(challengeId: 2, title: "옛날보다 500m더 뛰기", expectedTime: "0분", icon: "SampleImage", isSelected: false),
        ]
    }
}
