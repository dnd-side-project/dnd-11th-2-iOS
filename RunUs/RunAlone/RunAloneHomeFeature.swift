//
//  RunAloneHomeFeature.swift
//  RunUs
//
//  Created by Ryeong on 8/5/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RunAloneHomeFeature {
    
    @ObservableState
    struct State: Equatable {
        var showLocationPermissionAlert: Bool = false
        var navigateRunningView: Bool = false
        var mode: RunningMode = .normal
        var todayChallengeList: [TodayChallenge] = []
        var selectedChallengeId: Int?
        var selectedGoalType: GoalTypes?
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case onAppear
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
            case .binding(_),
                 .binding(\.navigateRunningView):
                return .none
            case .onAppear:
                return onAppearEffect()
            case .requestLocationPermission:
                locationManager.requestLocationPermission()
                return .none
            case .locationPermissionAlertChanged(let alert):
                state.showLocationPermissionAlert = alert
                return .none
            case .setTodayChallengeList(let list):
                state.todayChallengeList = list
                return .none
            case .selectChallenge(let id):
                state.todayChallengeList = state.todayChallengeList.map {
                    .init(id: $0.id,
                          title: $0.title,
                          expectedTime: $0.expectedTime,
                          icon: $0.icon,
                          isSelected: id == $0.id)
                }
                state.selectedChallengeId = id
                return .none
            case .startButtonTapped:
                let status = locationManager.authorizationStatus
                switch status {
                case .agree:
                    state.navigateRunningView = true
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
                break
            case .disagree:
                await send(.locationPermissionAlertChanged(true))
            case .notyet:
                await send(.requestLocationPermission)
            }
        }
    }
}
