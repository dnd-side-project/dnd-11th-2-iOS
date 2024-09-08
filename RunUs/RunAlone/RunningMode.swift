//
//  RunningMode.swift
//  RunUs
//
//  Created by Ryeong on 9/7/24.
//

import Foundation

enum RunningMode: String {
    case normal
    case challenge
    case goal
    
    var string: String {
        switch self {
        case .normal:
            return "바로 뛰기"
        case .challenge:
            return "챌린지"
        case .goal:
            return "목표 설정"
        }
    }
}
