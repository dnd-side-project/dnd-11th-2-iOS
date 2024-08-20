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
        var distance: String = "0.0"
        var kcal: Int = 0
        var pace: String = "0’00”"
        fileprivate var beforeDistance = ""
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
                    locationManager.startUpdatingLocation()
                } else {
                    runningStateManager.pause()
                    locationManager.stopUpdatingLocation()
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
                let pace = calculatePace(before: state.beforeDistance, after: state.distance)
                state.pace = pace
                state.beforeDistance = state.distance
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
    
    private func formatDistance(distance: String, newDistance: Double) -> String {
        let doubleDistance = (Double(distance) ?? 0.0) + newDistance/1000
        let stringDistance = String(format: "%.1f", doubleDistance)
        return stringDistance
    }
    
    private func calculatePace(before: String, after: String) -> String {
        guard let before = Double(before), let after = Double(after) else { return "0’00”" }
        let paceDistance = after-before == 0 ? 0 :  Int(1000 / (after - before))
        let paceMin: Int = paceDistance / 60
        let paceSec: Int = paceDistance % 60
        return "\(paceMin)’\(String(format: "%02d", paceSec))”"
    }
}
