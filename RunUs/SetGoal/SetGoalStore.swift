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
        var validateString: String = ""
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear(ViewEnvironment)
        case setGoal(goal: String, isBigGoal: Bool)
        case showValidateToast(isBigGoal: Bool)
        case setIsShowValidateToast(isShowValidateToast: Bool)
        case startButtonTapped
        case checkLocationPermission
        case requestLocationPermission
        case showLocationPermissionAlert
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
            case let .showValidateToast(isBigGoal):
                let (unit, suffix, max): (String, String, String)
                if state.goalType == .distance {
                    unit = isBigGoal ? "km" : "m"
                    suffix = "는"
                    max = "1000"
                } else {
                    unit = isBigGoal ? "시간" : "분"
                    suffix = "은"
                    max = "60"
                }
                state.validateString = "\(unit)\(suffix) \(max) 미만의 숫자만 입력 가능합니다."
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
                
            case .startButtonTapped:
                if locationManager.authorizationStatus == .agree {
                    return .run { [state] send in
                        try await NotificationManager.shared.checkNotificationPermission { runningStart(state: state) }
                    }
                } else {
                    return .send(.checkLocationPermission)
                }
                
            case .checkLocationPermission:
                let status = locationManager.authorizationStatus
                switch status {
                case .agree:
                    return .none
                case .disagree:
                    return .send(.showLocationPermissionAlert)
                case .notyet:
                    return .send(.requestLocationPermission)
                }
            case .requestLocationPermission:
                locationManager.requestLocationPermission()
                return .none
            case .showLocationPermissionAlert:
                AlertManager.shared.showAlert(title: Bundle.main.locationRequestDescription, mainButtonText: "설정", subButtonText: "취소", mainButtonAction: SystemManager.shared.openAppSetting)
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
    
    private func calcGoal(type: GoalTypes, bigGoal: Int?, smallGoal: Int?) -> Double {
        let big = Double(bigGoal ?? 0)
        let small = Double(smallGoal ?? 0)
        switch type {
        case .distance:
            return big + small * 0.001
        case .time:
            return big * 3600 + small * 60
        }
    }
    private func runningStart(state: State) {
        let goal = calcGoal(type: state.goalType, bigGoal: Int(state.bigGoal), smallGoal: Int(state.smallGoal))
        var runningStartInfo = RunningStartInfo(
            goalType: state.goalType,
            goalDistance: nil,
            goalTime: nil,
            achievementMode: .goal
        )
        
        switch state.goalType {
        case .distance:
            runningStartInfo.goalDistance = goal
        case .time:
            runningStartInfo.goalTime = Int(goal)
        }
        
        let navigationObject = NavigationObject(viewType: .running, data: runningStartInfo)
        state.viewEnvironment.navigate(navigationObject)
    }
}
