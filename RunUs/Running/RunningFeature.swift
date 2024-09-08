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
        var kcal: Int = 0
        var pace: String = "0’00”"
        fileprivate var beforeLocation: CLLocation?
    }
    
    enum Action: Equatable {
        case onAppear
        case isRunningChanged(Bool)
        case timeUpdated(Int)
        case locationUpdated(CLLocation?)
        case distanceUpdated(Double)
        case kcalUpdated(Int)
        case paceUpdated
    }
    
    @Dependency(\.runningStateManager) var runningStateManager
    
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
                    },
                    Effect.publisher({
                        runningStateManager.kcalPublisher
                            .map(Action.kcalUpdated)
                    })

                )
            case .isRunningChanged(let isRunning):
                state.isRunning = isRunning
                if isRunning {
                    runningStateManager.start()
                } else {
                    runningStateManager.pause()
                }
                return .none
            case .timeUpdated(let time):
                state.time = time
                // 5초에 한 번씩 pace check
                if time%5 == 0 {
                    return .send(.paceUpdated)
                }
                return .none
            case .locationUpdated(let location):
                let before = state.location
                state.location = location
                if state.time == 0 { state.beforeLocation = location }
                return .send(.distanceUpdated(calculateDistance(before: before,
                                                                after: location)))
            case .distanceUpdated(let distance):
                let distance = formatDistance(distance: state.distance, newDistance: distance)
                state.distance = distance
                return .none
            case .kcalUpdated(let kcal):
                state.kcal = kcal
                return .none
            case .paceUpdated:
                let distance = calculateDistance(before: state.beforeLocation, after: state.location)
                state.pace = calculatePace(distance: distance)
                state.beforeLocation = state.location
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
    
    private func formatDistance(distance: Double, newDistance: Double) -> Double {
        return distance + newDistance/1000
    }
    
    private func calculatePace(distance: Double) -> String {
        if distance == 0 { return "0’00”" }
        let time = Int(5000 / distance)
        let paceMin: Int = time / 60
        let paceSec: Int = time % 60
        return "\(paceMin)’\(String(format: "%02d", paceSec))”"
    }
}
