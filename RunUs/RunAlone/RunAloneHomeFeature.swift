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
        var showLocationPermissionAlert = false
        
    }
    
    enum Action: Equatable {
        case onAppear
        case requestLocationPermission
        case locationPermissionAlertChanged(Bool)
    }
    
    @Dependency(\.locationManager) var locationManager
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let status = locationManager.authorizationStatus
                switch status {
                case .agree:
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
            }
        }
    }
}
