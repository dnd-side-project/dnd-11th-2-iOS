//
//  RunAloneHomeFeature.swift
//  RunUs
//
//  Created by Ryeong on 8/5/24.
//

import Foundation
import SwiftUI
import MapKit
import ComposableArchitecture

@Reducer
struct RunAloneHomeFeature {
    
    @ObservableState
    struct State {
        var viewEnvironment: ViewEnvironment = ViewEnvironment()
        var userLocation: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)
        var showLocationPermissionAlert: Bool = false
        var mode: RunningMode = .normal
        var todayChallengeList: [TodayChallenge] = []
        var selectedChallengeId: Int = 0
        var selectedGoalType: GoalTypes?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear(ViewEnvironment)
        case setUserLocation
        case requestLocationPermission
        case locationPermissionAlertChanged(Bool)
        case setTodayChallengeList([TodayChallenge])
        case selectChallenge(Int)
        case selectGoal(GoalTypes)
        case startButtonTapped
        case changeMode(RunningMode)
    }
    
    @Dependency(\.locationManager) var locationManager
    @Dependency(\.runAloneAPI) var api
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            case let .onAppear(viewEnvironment):
                state.viewEnvironment = viewEnvironment
                return onAppearEffect()
            case .setUserLocation:
                state.userLocation = .region(
                        MKCoordinateRegion(
                            center: LocationManager.shared.getCurrentLocationCoordinator(),
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                    )
                return .none
            case .requestLocationPermission:
                locationManager.requestLocationPermission()
                return .none
            case .locationPermissionAlertChanged(let alert):
                state.showLocationPermissionAlert = alert
                return .none
            case .setTodayChallengeList(let list):
                state.todayChallengeList = list
                state.selectedChallengeId = state.todayChallengeList[0].id
                state.todayChallengeList[0].isSelected = true
                return .none
            case .selectChallenge(let id):
                state.selectedChallengeId = id
                state.todayChallengeList = state.todayChallengeList.map {
                    .init(id: $0.id,
                          title: $0.title,
                          expectedTime: $0.expectedTime,
                          icon: $0.icon,
                          isSelected: id == $0.id)
                }
                return .none
            case .startButtonTapped:
                let status = locationManager.authorizationStatus
                switch status {
                case .agree:
                    let runningStartInfo = RunningStartInfo(
                        challengeId: state.mode == .normal ? nil : state.selectedChallengeId,
                        goalDistance: 0,
                        goalTime: 0,
                        achievementMode: state.mode
                    )
                    let navigationObject = NavigationObject(viewType: .running, data: runningStartInfo)
                    state.viewEnvironment.navigationPath.append(navigationObject)
                    return .none
                case .disagree:
                    return .send(.locationPermissionAlertChanged(true))
                case .notyet:
                    return .send(.requestLocationPermission)
                }
            case .changeMode(let mode):
                state.mode = mode
                return .none
            case .selectGoal(let goal):
                state.selectedGoalType = goal
                return .none
            }
        }
    }
    
    private func onAppearEffect() -> Effect<Action> {
        .run { send in
            let data = try await api.getTodayChallenge()
            await send(.setTodayChallengeList(data))
            
            let status = locationManager.authorizationStatus
            switch status {
            case .agree:
                await send(.setUserLocation)
            case .disagree:
                await send(.locationPermissionAlertChanged(true))
            case .notyet:
                await send(.requestLocationPermission)
            }
        }
    }
}
