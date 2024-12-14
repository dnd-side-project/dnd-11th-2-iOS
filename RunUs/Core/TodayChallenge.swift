//
//  TodayChallenge.swift
//  RunUs
//
//  Created by Ryeong on 8/8/24.
//

import Foundation

struct TodayChallenge: Equatable, Decodable, Identifiable {
    let id: Int
    let title: String
    let expectedTime: String
    let icon: String
    let type: GoalTypes?
    let goalDistance: Double?
    let goalTime: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "challengeId"
        case title
        case expectedTime
        case icon
        case type
        case goalDistance
        case goalTime
    }
    
    init(id: Int, title: String, expectedTime: String, icon: String, type: String, goalDistance: Double?, goalTime: Int?) {
        self.id = id
        self.title = title
        self.expectedTime = expectedTime
        self.icon = icon
        self.type = GoalTypes(rawValue: type)
        self.goalDistance = goalDistance
        self.goalTime = goalTime
    }
}
