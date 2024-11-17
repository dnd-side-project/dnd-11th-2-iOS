//
//  RunningStartInfo.swift
//  RunUs
//
//  Created by seungyooooong on 9/16/24.
//

import Foundation

struct RunningStartInfo: Navigatable {
    let challengeId: Int?
    let goalDistance: Int?
    let goalTime: Int?
    let achievementMode: RunningMode
    let isNotificationAuthorized: Bool
    
    init (challengeId: Int? = nil, goalDistance: Int?, goalTime: Int?, achievementMode: RunningMode, isNotificationAuthorized: Bool) {
        self.challengeId = challengeId
        self.goalDistance = goalDistance
        self.goalTime = goalTime
        self.achievementMode = achievementMode
        self.isNotificationAuthorized = isNotificationAuthorized
    }
}
