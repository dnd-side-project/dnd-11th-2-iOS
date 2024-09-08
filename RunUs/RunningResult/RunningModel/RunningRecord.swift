//
//  RunningRecord.swift
//  RunUs
//
//  Created by Ryeong on 9/7/24.
//

import Foundation

struct RunningRecord: Decodable {
    let runningRecordId: Int
    let startAt: String
    let endAt: String
    let emotion: String
    let achievementMode: String
    let challenge: ChallengeResult?
    let goal: GoalResult?
    let runningData: RunningData
}
