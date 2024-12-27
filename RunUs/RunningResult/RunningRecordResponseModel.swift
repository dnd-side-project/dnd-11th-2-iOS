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
    let achievementResult: AchievementResult?
    let runningData: RunningResultData
}

struct AchievementResult: Decodable {
    let title: String
    let subTitle: String
    let iconUrl: String
    let isSuccess: Bool
    let percentage: Double?
}

struct RunningResultData: Decodable, Navigatable {
    let averagePace: String
    let runningTime: String
    let distanceMeter: Int
    let calorie: Int
    let route: [RURoute]?
}
