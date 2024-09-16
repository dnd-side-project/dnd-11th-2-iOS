//
//  SetGoalStore.swift
//  RunUs
//
//  Created by seungyooooong on 8/16/24.
//

import Foundation
import ComposableArchitecture

struct SetGoalStore: Reducer {
    @ObservableState
    struct State {
        var goalTypeObject: GoalTypeObject
        var viewEnvironment: ViewEnvironment = ViewEnvironment()
        var showLocationPermissionAlert: Bool = false
        var bigGoal: String = ""
        var smallGoal: String = ""

        init(goalTypeObject: GoalTypeObject) {
            self.goalTypeObject = goalTypeObject
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear(ViewEnvironment)
        case setGoal(goal: String, isBigGoal: Bool)
        case runningStart
        case requestLocationPermission
        case locationPermissionAlertChanged(Bool)
    }
    
    @Dependency(\.locationManager) var locationManager
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case let .setGoal(goal, isBigGoal):
                if isBigGoal {
                    state.bigGoal = goal
                } else {
                    state.smallGoal = goal
                }
                return .none
            case let .onAppear(viewEnvironment):
                state.viewEnvironment = viewEnvironment
                return .none
            case .runningStart:
                let status = locationManager.authorizationStatus
                switch status {
                case .agree:
                    let runningStartInfo = RunningStartInfo(
                        challengeId: nil,
                        goalDistance: state.goalTypeObject.type == .distance ? Int(state.bigGoal) ?? 0 : 0,    // TODO: bigGoal + smallGoal Int
                        goalTime: state.goalTypeObject.type == .time ? Int(state.bigGoal) ?? 0 : 0,    // TODO: bigGoal + smallGoal Int
                        achievementMode: .goal
                    )
                    let navigationObject = NavigationObject(viewType: .running, data: runningStartInfo)
                    state.viewEnvironment.navigationPath.append(navigationObject)
                    return .none
                case .disagree:
                    return .send(.locationPermissionAlertChanged(true))
                case .notyet:
                    return .send(.requestLocationPermission)
                }
            case .requestLocationPermission:
                locationManager.requestLocationPermission()
                return .none
            case .locationPermissionAlertChanged(let alert):
                state.showLocationPermissionAlert = alert
                return .none
            case .binding(\.bigGoal):
                return .none
            case .binding(\.smallGoal):
                return .none
            case .binding(_):
                return .none
            }
        }
    }
}
