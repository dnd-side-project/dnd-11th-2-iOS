//
//  RunningFeature.swift
//  RunUs
//
//  Created by Ryeong on 8/16/24.
//

import Foundation
import SwiftUI
import MapKit
import ComposableArchitecture
import Combine
import CoreLocation

@Reducer
struct RunningFeature {
    @ObservableState
    struct State {
        var userLocation: MapCameraPosition = .region(
            MKCoordinateRegion(
                center: LocationManager.shared.getCurrentLocationCoordinator(),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
        var isRunning: Bool = true
        var time: Int = 0
        var location: CLLocation?
        var distance: Double = 0
        var kcal: Int = 0
        var pace: String = "0’00”"
        var isRunningEnd: Bool = false
        fileprivate var beforeLocation: CLLocation?
        var startAt: String
        var endAt: String = ""
        var startLocation: String = ""
        var endLocation: String = ""
        var challengeId: Int?
        var goalDistance: Int?
        var goalTime: Int?
        var achievementMode: RunningMode
        
        init(runningStartInfo: RunningStartInfo) {
            self.startAt = Date().formatStringHyphen()
            self.challengeId = runningStartInfo.challengeId
            self.goalDistance = runningStartInfo.goalDistance
            self.goalTime = runningStartInfo.goalTime
            self.achievementMode = runningStartInfo.achievementMode
        }
        
        func getRunningResult(emotion: Emotions) -> RunningResult {
            .init(startAt: self.startAt,
                  endAt: self.endAt,
                  startLocation: self.startLocation,
                  endLocation: self.endLocation,
                  emotion: emotion.entity,
                  challengeId: self.challengeId,
                  goalDistance: self.goalDistance,
                  goalTime: self.goalTime,
                  achievementMode: achievementMode.rawValue,
                  runningData: .init(averagePace: self.pace,
                                     runningTime: self.time.toTimeString(),
                                     distanceMeter: distanceKMtoM(km: self.distance),
                                     calorie: self.kcal))
        }
        
        private func distanceKMtoM(km: Double) -> Int {
            return Int(km*1000)
        }
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case isRunningChanged(Bool)
        case timeUpdated(Int)
        case locationUpdated(CLLocation?)
        case distanceUpdated(Double)
        case kcalUpdated(Int)
        case paceUpdated
        case runningEnd
        case setStartLocation(String)
        case setEndLocation(String)
    }
    
    @Dependency(\.runningStateManager) var runningStateManager
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
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
                    }),
                    Effect.run { send in
                        let address = await LocationManager.shared.getAddress()
                        await send(.setStartLocation(address))
                    }
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
            case .runningEnd:
                state.endAt = Date().formatStringHyphen()
                state.isRunningEnd = true
                return .run { send in
                    let address = await LocationManager.shared.getAddress()
                    await send(.setEndLocation(address))
                }
            case .setStartLocation(let address):
                state.startLocation = address
                return .none
            case .setEndLocation(let address):
                state.endLocation = address
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
