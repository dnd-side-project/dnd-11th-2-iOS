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
        var runningResult: RunningResult
        var date: String
        var emotion: Emotions
        var hasChallenge: Bool = false
        var challengeResult: ChallengeResult?
        var goalResult: GoalResult?
        var averagePace: String
        var runningTime: String
        var distance: Double
        var kcal: Int
        
        init(runningResult: RunningResult) {
            self.runningResult = runningResult
            let startAt = runningResult.startAt.formatDateHyphen().formatStringDot()
            let endAt = runningResult.endAt.formatDateHyphen().formatStringDot()
            self.date = "\(startAt) ~ \(endAt)"
            self.emotion = runningResult.emotion.getEmotion()
            self.averagePace = runningResult.runningData.averagePace
            self.runningTime = runningResult.runningData.runningTime
            self.distance = Double(runningResult.runningData.distanceMeter) * 0.001
            self.kcal = runningResult.runningData.calorie
        }
    }
    
    enum Action {
        case onAppear
        case setRunningRecord(RunningRecordResponseModel)
    }
    
    @Dependency(\.runningRecordAPI) var api
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let runningResult = state.runningResult
                return .run { send in
                    let record: RunningRecordResponseModel = try await api.postRunningRecord(result: runningResult)
                    await send(.setRunningRecord(record))
                }
            case .setRunningRecord(let record):
                let startAt = record.startAt.formatDateHyphen().formatStringDot()
                let endAt = record.endAt.formatDateHyphen().formatStringDot()
                state.date = "\(startAt) ~ \(endAt)"
                state.emotion = record.emotion.getEmotion()
                state.challengeResult = record.challenge
                state.goalResult = record.goal
                state.averagePace = record.runningData.averagePace
                state.distance = distanceMtoKM(m: record.runningData.distanceMeter)
                state.runningTime = record.runningData.runningTime
                state.kcal = record.runningData.calorie
                return .none
            }
        }
    }
    
    func distanceMtoKM(m: Int) -> Double {
        Double(m) * 0.001
    }
}
