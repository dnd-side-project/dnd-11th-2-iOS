//
//  ChallengeResult.swift
//  RunUs
//
//  Created by Ryeong on 8/26/24.
//

import Foundation

struct ChallengeResult {
    var icon: String
    var title: String
    var subtitle: String
    var isSuccess: Bool
    
    init() {
        self.icon = "soso-emotion"
        self.title = "오늘 30분 동안 뛰기"
//        self.subtitle = "정말 대단해요! 잘하셨어요"
        self.subtitle = "아쉬워요. 내일 다시 도전해보세요!"
        self.isSuccess = false
    }
}
