//
//  RunningMood.swift
//  RunUs
//
//  Created by Ryeong on 8/26/24.
//

import Foundation
import SwiftUI

enum RunningMood {
    case veryGood
    case good
    case soso
    case bad
    case veryBad
    
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
        }
    }
}
