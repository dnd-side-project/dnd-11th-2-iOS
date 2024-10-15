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
        var runningRecordId: Int? = nil
        var runningResult: RunningResult? = nil
        var date: String = ""
        var emotion: Emotions
        var hasChallenge: Bool = false
        var challengeResult: ChallengeResult?
        var goalResult: GoalResult?
        var averagePace: String = "-’--”"
        var runningTime: String
        var distance: Double
        var kcal: Int
        
        init(runningResult: RunningResult) {
            self.runningResult = runningResult
            let startAt = runningResult.startAt.formatDateHyphen().formatStringDot()
            let endAt = runningResult.endAt.formatDateHyphen().formatStringDot()
            self.date = "\(startAt) ~ \(endAt)"
            self.emotion = runningResult.emotion.getEmotion()
            self.runningTime = runningResult.runningData.runningTime
            self.distance = Double(runningResult.runningData.distanceMeter) * 0.001
            self.kcal = runningResult.runningData.calorie
        }
        
        init(runningRecord: RunningRecord) {
            self.runningRecordId = runningRecord.runningRecordId
            self.emotion = runningRecord.emotion.getEmotion()
            self.averagePace = runningRecord.runningData.averagePace
            self.runningTime = runningRecord.runningData.runningTime
            self.distance = Double(runningRecord.runningData.distanceMeter) * 0.001
            self.kcal = runningRecord.runningData.calorie
        }
    }
    
    enum Action {
        case onAppear
        case setRunningRecord(RunningRecordResponseModel)
    }
    
    @Dependency(\.runningResultAPI) var runningResultAPI
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.runningRecordId == nil {
                    let runningResult = state.runningResult!
                    return .run { send in
                        let record: RunningRecordResponseModel = try await runningResultAPI.postRunningRecord(result: runningResult)
                        await send(.setRunningRecord(record))
                    }
                } else {
                    let runningRecordId = state.runningRecordId!
                    return .run { send in
                        let record: RunningRecordResponseModel = try await runningResultAPI.getRunningRecord(runningRecordId: runningRecordId)
                        await send(.setRunningRecord(record))
                    }
                }
            case .setRunningRecord(let record):
                let startAt = record.startAt.formatDateHyphen().formatStringDot()
                let endAt = record.endAt.formatDateHyphen().formatStringDot()
                state.date = "\(startAt) ~ \(endAt)"
                state.emotion = record.emotion.getEmotion()
                state.challengeResult = record.challenge
                state.goalResult = record.goal
                state.averagePace = record.runningData.averagePace
                state.distance = Double(record.runningData.distanceMeter) * 0.001
                state.runningTime = record.runningData.runningTime
                state.kcal = record.runningData.calorie
                return .none
            }
        }
    }
}
