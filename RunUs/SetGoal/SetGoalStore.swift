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
        var bigGoal: String = ""
        var smallGoal: String = ""
    }
    
    enum Action: Equatable {
    }
    
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        }
    }
}
