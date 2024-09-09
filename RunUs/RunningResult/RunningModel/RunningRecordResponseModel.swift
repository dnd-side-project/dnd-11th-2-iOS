//
//  RunningRecordResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 9/9/24.
//

import Foundation

struct RunningRecordResponseModel: Decodable {
    let runningRecordId: Int
    let startAt: String
    let endAt: String
    let emotion: String
    let achievementMode: String
    let challenge: ChallengeResult?
    let goal: GoalResult?
    let runningData: RunningData
}
