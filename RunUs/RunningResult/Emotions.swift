//
//  Emotions.swift
//  RunUs
//
//  Created by Ryeong on 8/26/24.
//

import Foundation
import SwiftUI

enum Emotions: String, CaseIterable, Codable, CodingKey {
    case veryBad = "very-bad"
    case bad
    case soso
    case good
    case veryGood = "very-good"
    case none
    
    var icon: ImageResource {
        switch self {
        case .veryBad:
            return .veryBadEmotion
        case .bad:
            return .badEmotion
        case .soso:
            return .sosoEmotion
        case .good:
            return .goodEmotion
        case .veryGood:
            return .veryGoodEmotion
        case .none:
            return .xmark
        }
    }
    
    var text: String {
        switch self {
        case .veryBad:
            return "별로에요!"
        case .bad:
            return "잘 모르겠어요"
        case .soso:
            return "나쁘지않아요"
        case .good:
            return "좋아요!"
        case .veryGood:
            return "최고에요!"
        case .none:
            return ""
        }
    }
    
    // MARK:  server 표기
    var entity: String {
        switch self {
        case .veryBad:
            return "very-bad"
        case .bad:
            return "bad"
        case .soso:
            return "soso"
        case .good:
            return "good"
        case .veryGood:
            return "very-good"
        case .none:
            return ""
        }
    }
}
