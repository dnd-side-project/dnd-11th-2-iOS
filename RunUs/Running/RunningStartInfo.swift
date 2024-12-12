//
//  RunningStartInfo.swift
//  RunUs
//
//  Created by seungyooooong on 9/16/24.
//

import Foundation

struct RunningStartInfo: Navigatable {
    var challengeId: Int?
    var goalType: GoalTypes?
    var goalDistance: Double?
    var goalTime: Int?
    let achievementMode: RunningMode
    
    init (challengeId: Int? = nil, goalType: GoalTypes? = nil, goalDistance: Double?, goalTime: Int?, achievementMode: RunningMode) {
        self.challengeId = challengeId
        self.goalType = goalType
        self.goalDistance = goalDistance
        self.goalTime = goalTime
        self.achievementMode = achievementMode
    }
}
