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
        case setUserLocation
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
                return .run { send in
                    if locationManager.authorizationStatus == .agree {
                        await send(.setUserLocation)
                    }
                }
            case .checkLocationPermission:
                return .none
            case .setUserLocation:
                state.userLocation = .region(
                    MKCoordinateRegion(
                        center: LocationManager.shared.getCurrentLocationCoordinator(),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )
                return .none
            case .startButtonTapped:
                if locationManager.authorizationStatus == .agree {
                    let runningStartInfo = RunningStartInfo(
                        challengeId: state.viewEnvironment.selectedRunningMode == .normal ? nil : state.challenges[state.selectedChallengeIndex].id,
                        goalDistance: nil,
                        goalTime: nil,
                        achievementMode: state.viewEnvironment.selectedRunningMode
                    )
                    let navigationObject = NavigationObject(viewType: .running, data: runningStartInfo)
                    state.viewEnvironment.navigate(navigationObject)
                    return .none
                } else {
                    return .send(.checkLocationPermission)
                }
            case .selectGoal(let goal):
                state.selectedGoalType = goal
                return .none
                
            case let .selectChallenge(selectedChallengeIndex):
                state.selectedChallengeIndex = selectedChallengeIndex
                return .none
            }
        }
    }
}
