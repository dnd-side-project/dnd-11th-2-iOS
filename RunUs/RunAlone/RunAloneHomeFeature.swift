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
        case todayChallengeListChanged([TodayChallenge])
        case selectedChallengeChanged(Int)
    }
    
    @Dependency(\.locationManager) var locationManager
    @Dependency(\.serverNetwork) var serverNetwork
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let data = try await serverNetwork.getTodayChallenge()
                    await send(.todayChallengeListChanged(data))
                    
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

            case .requestLocationPermission:
                locationManager.requestLocationPermission()
                return .none
            case .locationPermissionAlertChanged(let alert):
                state.showLocationPermissionAlert = alert
                return .none
            case .binding(_):
                return .none
            case .todayChallengeListChanged(let list):
                state.todayChallengeList = list
                return .none
            case .selectedChallengeChanged(let id):
                state.todayChallengeList = state.todayChallengeList.map {
                    .init(id: $0.id,
                          imageUrl: $0.imageUrl,
                          title: $0.title,
                          estimatedMinute: $0.estimatedMinute,
                          isSelected: id == $0.id)
                }
                return .none
            }
        }
    }
}
