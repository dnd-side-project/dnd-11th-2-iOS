//
//  RunningMood.swift
//  RunUs
//
//  Created by Ryeong on 8/26/24.
//

import Foundation
import SwiftUI

enum RunningMood: Int, CaseIterable {
    case veryGood
    case good
    case soso
    case bad
    case veryBad
    case none
    
    var icon: ImageResource {
        switch self {
        case .veryGood:
            return .veryGoodEmotion
        case .good:
            return .goodEmotion
        case .soso:
            return .sosoEmotion
        case .bad:
            return .badEmotion
        case .veryBad:
            return .veryBadEmotion
        case .none:
            return .xmark
        }
    }
    
    var text: String {
        switch self {
        case .veryGood:
            return "최고에요!"
        case .good:
            return "좋아요!"
        case .soso:
            return "나쁘지않아요"
        case .bad:
            return "잘 모르겠어요"
        case .veryBad:
            return "별로에요!"
        case .none:
            return ""
        }
    }
    
    //server
    var entity: String {
        switch self {
        case .veryGood:
            return "very-good"
        case .good:
            return "good"
        case .soso:
            return "soso"
        case .bad:
            return "bad"
        case .veryBad:
            return "very-bad"
        case .none:
            return ""
        }
    }
}
