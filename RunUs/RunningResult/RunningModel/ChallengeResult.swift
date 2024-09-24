//
//  ChallengeResult.swift
//  RunUs
//
//  Created by Ryeong on 8/26/24.
//

import Foundation

struct ChallengeResult: Decodable {
    var challengeId: Int
    var iconUrl: String
    var title: String
    var subTitle: String
    var isSuccess: Bool
    
    static func empty() -> Self {
        .init(challengeId: 0,
              iconUrl: "",
              title: "",
              subTitle: "",
              isSuccess: true
        )
    }
}

struct GoalResult: Decodable {
    var title: String
    var subTitle: String
    var iconUrl: String
    var isSuccess: Bool
}
