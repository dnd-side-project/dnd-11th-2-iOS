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
    //TODO: API 나오면 변경
    func getTodayChallenge() async throws -> [TodayChallenge] {
        return [
            .init(id: 0, imageUrl: "SampleImage", title: "어제보다 500m더 뛰기", estimatedMinute: 12, isSelected: false),
            .init(id: 1, imageUrl: "SampleImage", title: "저번보다 500m더 뛰기", estimatedMinute: 99999, isSelected: false),
            .init(id: 2, imageUrl: "SampleImage", title: "옛날보다 500m더 뛰기", estimatedMinute: 0, isSelected: false),
        ]
    }
}

final class RunAloneAPIMock: RunAloneAPI {
    func getTodayChallenge() async throws -> [TodayChallenge] {
        return [
            .init(id: 0, imageUrl: "SampleImage", title: "어제보다 500m더 뛰기", estimatedMinute: 12, isSelected: false),
            .init(id: 1, imageUrl: "SampleImage", title: "저번보다 500m더 뛰기", estimatedMinute: 99999, isSelected: false),
            .init(id: 2, imageUrl: "SampleImage", title: "옛날보다 500m더 뛰기", estimatedMinute: 0, isSelected: false),
        ]
    }
}
