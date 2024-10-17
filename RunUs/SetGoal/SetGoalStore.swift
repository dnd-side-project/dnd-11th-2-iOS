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
        var goalType: GoalTypes
        var viewEnvironment: ViewEnvironment = ViewEnvironment()
        var showLocationPermissionAlert: Bool = false
        var bigGoal: String = ""
        var smallGoal: String = ""
        var isShowValidateToast: Bool = false
        var toastTimer: Timer? = nil
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear(ViewEnvironment)
        case setGoal(goal: String, isBigGoal: Bool)
        case showValidateToast
        case setIsShowValidateToast(isShowValidateToast: Bool)
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
            case .showValidateToast:
                if state.isShowValidateToast { return .none }
                return .merge (
                    .send(.setIsShowValidateToast(isShowValidateToast: true)),
                    .run { send in
                        try await Task.sleep(for: .seconds(3))
                        await send(.setIsShowValidateToast(isShowValidateToast: false))
                    }
                )
            case let .setIsShowValidateToast(isShowValidateToast):
                state.isShowValidateToast = isShowValidateToast
                return .none
            case .runningStart:
                let status = locationManager.authorizationStatus
                switch status {
                case .agree:
                    let goal = calcGoal(type: state.goalType, bigGoal: Int(state.bigGoal), smallGoal: Int(state.smallGoal))
                    let runningStartInfo = RunningStartInfo(
                        challengeId: nil,
                        goalDistance: state.goalType == .distance ? goal : nil,
                        goalTime: state.goalType == .time ? goal : nil,
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
    private func calcGoal(type: GoalTypes, bigGoal: Int?, smallGoal: Int?) -> Int {
        let big = bigGoal == nil ? 0 : bigGoal!
        let small = smallGoal == nil ? 0 : smallGoal!
        switch type {
        case .distance:
            return big * 1000 + small
        case .time:
            return big * 3600 + small * 60
        }
    }
}
