//
//  RunAloneFeature.swift
//  RunUs
//
//  Created by Ryeong on 8/5/24.
//

import Foundation
import SwiftUI
import MapKit
import ComposableArchitecture

@Reducer
struct RunAloneFeature {
    @ObservableState
    struct State {
        var viewEnvironment: ViewEnvironment = ViewEnvironment()
        var userLocation: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)
        
        var selectedChallengeIndex: Int = 0
        var challenges: [TodayChallenge] = []
        
        var selectedGoalType: GoalTypes?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear(viewEnvironment: ViewEnvironment)
        case checkLocationPermission
        case selectGoal(GoalTypes)
        case startButtonTapped
        case selectChallenge(Int)
    }
    
    @Dependency(\.locationManager) var locationManager
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            case let .onAppear(viewEnvironment):
                state.viewEnvironment = viewEnvironment
                return .none
            case .checkLocationPermission:
                return .none
            case .selectGoal(let goal):
                state.selectedGoalType = goal
                return .none
            case .startButtonTapped:
                if locationManager.authorizationStatus == .agree {
                    return .run { [state] send in
                        try await NotificationManager.shared.checkNotificationPermission { runningStart(state: state) }
                    }
                } else {
                    return .send(.checkLocationPermission)
                }
                
            case let .selectChallenge(selectedChallengeIndex):
                state.selectedChallengeIndex = selectedChallengeIndex
                return .none
            }
        }
    }
    
    private func runningStart(state: State) {
        var runningStartInfo = RunningStartInfo(
            challengeId: nil,
            goalType: nil,
            goalDistance: nil,
            goalTime: nil,
            achievementMode: state.viewEnvironment.selectedRunningMode
        )
        if state.viewEnvironment.selectedRunningMode == .challenge {
            let challenge = state.challenges[state.selectedChallengeIndex]
            runningStartInfo.challengeId = challenge.id
            runningStartInfo.challengeTitle = challenge.title
            runningStartInfo.goalType = challenge.type
            runningStartInfo.goalDistance = challenge.goalDistance
            runningStartInfo.goalTime = challenge.goalTime
        }
        let navigationObject = NavigationObject(viewType: .running, data: runningStartInfo)
        state.viewEnvironment.navigate(navigationObject)
    }
}
