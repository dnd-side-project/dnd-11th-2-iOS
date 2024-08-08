//
//  RunAloneDependency.swift
//  RunUs
//
//  Created by Ryeong on 8/5/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var locationManager: LocationManager {
        get { self[LocationManagerKey.self] }
        set { self[LocationManagerKey.self] = newValue }
    }
    
    var serverNetwork: ServerNetworkKey {
        get { self[ServerNetworkKey.self] }
        set { self[ServerNetworkKey.self] = newValue }
    }
}

struct LocationManagerKey: DependencyKey {
    static let liveValue = LocationManager()
}

struct ServerNetworkKey {
    var getTodayChallenge: () async throws -> [TodayChallenge]
}

extension ServerNetworkKey: DependencyKey {
    static let liveValue = Self {
    getTodayChallenge: do {
        let todayChallengeList: [TodayChallenge] = [
            .init(id: 0, imageUrl: "SampleImage", title: "어제보다 500m더 뛰기", estimatedMinute: 12, isSelected: false),
            .init(id: 1, imageUrl: "SampleImage", title: "저번보다 500m더 뛰기", estimatedMinute: 99999, isSelected: false),
            .init(id: 2, imageUrl: "SampleImage", title: "옛날보다 500m더 뛰기", estimatedMinute: 0, isSelected: false),
        ]
        return todayChallengeList
    }
    }
}
