//
//  RunningResult.swift
//  RunUs
//
//  Created by Ryeong on 9/7/24.
//

import Foundation

struct RunningResult: Encodable, Navigatable {
    let startAt: String
    let endAt: String
    let startLocation: String
    let endLocation: String
    let emotion: String
    let achievementMode: String
    let challengeValues: ChallengeValues?
    let goalValues: GoalValues?
    let runningData: RunningData
}

struct ChallengeValues: Encodable, Navigatable {
    let challengeId: Int
    let isSuccess: Bool
}

struct GoalValues: Encodable, Navigatable {
    let goalDistance: Int?
    let goalTime: Int?
    let isSuccess: Bool
    
    init(goalDistance: Int? = nil, goalTime: Int? = nil, isSuccess: Bool) {
        self.goalDistance = goalDistance
        self.goalTime = goalTime
        self.isSuccess = isSuccess
    }
}
