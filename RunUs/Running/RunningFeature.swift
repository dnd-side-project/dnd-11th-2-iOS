//
//  RunningFeature.swift
//  RunUs
//
//  Created by Ryeong on 8/16/24.
//

import Foundation
import ComposableArchitecture
import Combine
import CoreLocation

@Reducer
struct RunningFeature {
    @ObservableState
    struct State: Equatable {
        var isRunning: Bool = true
        var time: Int = 0
        var location: CLLocation?
        var distance: Double = 0
    }
    
    enum Action: Equatable {
        case onAppear
        case isRunningChanged(Bool)
        case timeUpdated(Int)
        case locationUpdated(CLLocation?)
        case distanceUpdated(Double)
    }
    
    @Dependency(\.runningStateManager) var runningStateManager
    @Dependency(\.locationManager) var locationManager
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    .send(.isRunningChanged(true)),
                    Effect.publisher {
                        runningStateManager.locationPublisher
                            .map(Action.locationUpdated)
                    },
                    Effect.publisher {
                        runningStateManager.timePublisher
                            .map(Action.timeUpdated)
                    }
                )
            case .isRunningChanged(let isRunning):
                state.isRunning = isRunning
                if isRunning {
                    runningStateManager.start()
                    locationManager.startUpdatingLocation()
                } else {
                    runningStateManager.pause()
                    locationManager.stopUpdatingLocation()
                }
                return .none
            case .timeUpdated(let time):
                state.time = time
                return .none
            case .locationUpdated(let location):
                let before = state.location
                state.location = location
                return .send(.distanceUpdated(calculateDistance(before: before, after: location)))
            case .distanceUpdated(let distance):
                let newDistance = state.distance + distance/1000
                state.distance = (newDistance * 10).rounded() / 10.0
                return .none
            }
        }
    }
}

extension RunningFeature {
    private func calculateDistance(before: CLLocation?, after: CLLocation?) -> Double {
        guard let before = before, let after = after else { return 0 }
        return after.distance(from: before)
    }
}
