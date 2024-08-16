//
//  RunningFeature.swift
//  RunUs
//
//  Created by Ryeong on 8/16/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RunningFeature {
    @ObservableState
    struct State: Equatable {
        var isRunning: Bool = true
    }
    
    enum Action: Equatable {
        case isRunningChanged(Bool)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .isRunningChanged(let isRunning):
                state.isRunning = isRunning
                return .none
            }
        }
    }
}
