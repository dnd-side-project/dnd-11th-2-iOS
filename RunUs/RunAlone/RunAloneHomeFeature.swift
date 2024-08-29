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
    
    struct State: Equatable {
        @BindingState var showLocationPermissionAlert: Bool = false
        @BindingState var todayChallengeToggle: Bool = true
        var selectedChallengeId: Int = 0
        var todayChallengeList: [TodayChallenge] = []
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case requestLocationPermission
        case locationPermissionAlertChanged(Bool)
        case setTodayChallengeList([TodayChallenge])
        case selectChallenge(Int)
        case startButtonTapped
    }
    
    @Dependency(\.locationManager) var locationManager
    @Dependency(\.runAloneAPI) var api
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(_):
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
                state.selectedChallengeId = id
                return .none
            case .startButtonTapped:
                return startButtonTappedEffect()
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
    
    private func startButtonTappedEffect() -> Effect<Action> {
        let status = locationManager.authorizationStatus
        switch status {
        case .agree:
            //TODO: 목표 설정 + 시작 화면 구현후 로직 구현
            return .none
        case .disagree:
            return .send(.locationPermissionAlertChanged(true))
        case .notyet:
            return .send(.requestLocationPermission)
        }
    }
}
