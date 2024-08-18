//
//  SetGoalStore.swift
//  RunUs
//
//  Created by seungyooooong on 8/16/24.
//

import Foundation
import ComposableArchitecture

struct SetGoalStore: Reducer {
    struct State: Equatable {
        var goalTypeObject: GoalTypeObject
        @BindingState var bigGoal: String = ""
        @BindingState var smallGoal: String = ""
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case setGoal(goal: String, isBigGoal: Bool)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            case let .setGoal(goal, isBigGoal):
                if isBigGoal {
                    state.bigGoal = goal
                } else {
                    state.smallGoal = goal
                }
                return .none
            }
        }
    }
}
