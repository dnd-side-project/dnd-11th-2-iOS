//
//  RunningResultFeature.swift
//  RunUs
//
//  Created by Ryeong on 8/26/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RunningResultFeature {
    
    @ObservableState
    struct State {
        var date: String = "24. 07. 20. 오후 7:00 ~ 24. 07. 20. 오후 7:30"
        var mood: RunningMood = .veryGood
        var hasChallenge: Bool = false
        var challengeResult: ChallengeResult = .init()
        var averagePace: String = "0’00”"
        var runningTime: String = "30:15"
        var distance: Double = 2.07
        var kcal: Int = 200
    }
    
    enum Action {
        case onAppear
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
