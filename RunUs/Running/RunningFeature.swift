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
        var userLocation: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)
        var routeCoordinates: [CLLocationCoordinate2D] = []
        var polyline: MKPolyline?
        var routeSegments: [RouteSegment] = []
        var reStartCoordinate: CLLocationCoordinate2D? = nil
        var runningState: RunningState = .running
        var time: Int = 0
        var location: CLLocation?
        var distance: Double = 0.000
        var kcal: Float = 0
        var pace: String = "-’--”"
        fileprivate var beforeLocation: CLLocation?
        var startAt: String
        var endAt: String = ""
        var startLocation: String = ""
        var endLocation: String = ""
        var challengeId: Int?
        var goalType: GoalTypes?
        var goalDistance: Double?
        var goalTime: Int?
        var achievementMode: RunningMode
        
        init(runningStartInfo: RunningStartInfo) {
            self.startAt = Date().formatStringHyphen()
            self.challengeId = runningStartInfo.challengeId
            self.goalType = runningStartInfo.goalType
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
                  goalDistance: self.goalDistance.map { Int($0 * 1000) },
                  goalTime: self.goalTime,
                  achievementMode: achievementMode.rawValue,
                  runningData: .init(runningTime: self.time.toTimeString(),
                                     distanceMeter: Int(self.distance * 1000),  // MARK: km -> m
                                     calorie: Int(self.kcal)))  // MARK: Float -> Int
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case setRunningState(RunningState)
        case timeUpdated(Int)
        case locationUpdated(CLLocation?)
        case runningRestart(CLLocation?)
        case updateRouteSegments(CLLocation?)
        case drawPolyline
        case distanceUpdated(Double)
        case kcalUpdated(Float)
        case paceUpdated
        case runningEnd
        case resetRunningData
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
                    .send(.setRunningState(.running)),
                    Effect.publisher {
                        runningStateManager.locationPublisher
                            .map(Action.locationUpdated)
                    },
                    Effect.publisher {
                        runningStateManager.timePublisher
                            .map(Action.timeUpdated)
                    },
                    Effect.publisher {
                        runningStateManager.restartPublisher
                            .map(Action.runningRestart)
                    },
                    Effect.run { send in
                        let address = await LocationManager.shared.getAddress()
                        await send(.setStartLocation(address))
                    }
                )
            case .setRunningState(let runningState):
                state.runningState = runningState
                switch runningState {
                case .running:
                    runningStateManager.start()
                case .pause:
                    runningStateManager.pause()
                case .stop:
                    runningStateManager.stop()
                }
                return .none
            case .timeUpdated(let time):
                state.time = time
                if state.time == 3 { // TODO: 추후 조건화 및 텍스트 수정
                    return .run { _ in
                        let settings = await UNUserNotificationCenter.current().notificationSettings()
                        if settings.authorizationStatus == .authorized {
                            try await NotificationManager.shared.pushSuccessNotification(title: "오늘 30분 동안 뛰기 성공!")
                        }
                    }
                }
                // 5초에 한 번씩 pace check
                if time % 5 == 0 {
                    return .merge(
                        .send(.paceUpdated),
                        .send(.kcalUpdated(calculateKcal(pace: state.pace)))
                    )
                }
                return .send(.kcalUpdated(calculateKcal(pace: state.pace)))
            case .locationUpdated(let location):
                let before = state.location
                state.location = location
                if state.time == 0 { state.beforeLocation = location }
                return .run { send in
                    await send(.updateRouteSegments(location))
                    await send(.drawPolyline)
                    await send(.distanceUpdated(calculateDistance(before: before, after: location)))
                }
            case .runningRestart(let location):
                state.location = location
                state.reStartCoordinate = location?.coordinate
                return .none
            case .updateRouteSegments(let location):
                guard let location = location else { return .none }
                
                let newCoordinate = location.coordinate
                let startCoordinate = state.reStartCoordinate == nil ? state.routeCoordinates.last : state.reStartCoordinate
                if state.reStartCoordinate != nil { state.reStartCoordinate = nil }
                
                state.routeCoordinates.append(newCoordinate)
                guard let startCoordinate = startCoordinate else { return .none }
                
                state.routeSegments.append(RouteSegment(start: startCoordinate, end: newCoordinate))
                return .none
            case .drawPolyline:
                state.polyline = MKPolyline(coordinates: state.routeCoordinates, count: state.routeCoordinates.count)
                return .none
            case .distanceUpdated(let distance):
                state.distance = state.distance + distance
                return .none
            case .kcalUpdated(let kcal):
                state.kcal = state.kcal + kcal
                return .none
            case .paceUpdated:
                let distance = calculateDistance(before: state.beforeLocation, after: state.location)
                state.pace = calculatePace(distance: distance)
                state.beforeLocation = state.location
                return .none
            case .runningEnd:
                state.endAt = Date().formatStringHyphen()
                return .run { send in
                    let address = await LocationManager.shared.getAddress()
                    await send(.setEndLocation(address))
                }
            case .resetRunningData:
                state.time = 0
                state.distance = 0.000
                state.kcal = 0
                state.pace = "-’--”"
                state.reStartCoordinate = nil
                return .none
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
        return after.distance(from: before) / 1000  // MARK: m -> km
    }
    
    private func calculatePace(distance: Double) -> String {
        if distance < 0.0014 { return "-’--”" }    // MARK: 시속 약 1km 미만에서 페이스를 계산하지 않음
        let pace = Int(5 / distance)
        let paceMin: Int = pace / 60
        let paceSec: Int = pace % 60
        return "\(paceMin)’\(String(format: "%02d", paceSec))”"
    }
    
    private func calculateKcal(pace: String) -> Float {
        if pace == "-’--”" { return 0 }
        else {
            let runningPace = Int(pace.trimmingCharacters(in: ["”"]).split(separator: "’").joined())!
            if runningPace > 1845 { // MARK: light walking (88kcal per 30min)
                return 88 / 1800
            } else if runningPace > 1230 { // MARK: normal walking (110kcal per 30min)
                return 110 / 1800
            } else if runningPace > 1043 { // MARK: hard walking (135kcal per 30min)
                return 135 / 1800
            } else if runningPace > 923 { // MARK: light jogging (189kcal per 30min)
                return 189 / 1800
            } else if runningPace > 820 { // MARK: normal jogging (220kcal per 30min)
                return 220 / 1800
            } else if runningPace > 730 { // MARK: hard jogging (261kcal per 30min)
                return 260 / 1800
            } else if runningPace > 611 { // MARK: light running (308kcal per 30min)
                return 308 / 1800
            } else if runningPace > 519 { // MARK: normal running (346kcal per 30min)
                return 346 / 1800
            } else { // MARK: hard running (371kcal per 30min)
                return 317 / 1800
            }
        }
    }
}
