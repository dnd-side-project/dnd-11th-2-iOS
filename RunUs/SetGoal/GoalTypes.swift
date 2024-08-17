//
//  GoalTypes.swift
//  RunUs
//
//  Created by seungyooooong on 8/12/24.
//

import Foundation
import SwiftUI

enum GoalTypes: String {
    case time
    case distance
}

struct TypeObject: Equatable {
    let type: GoalTypes
    let text: String
    let icon: ImageResource
    
    init(goalType: GoalTypes) {
        self.type = goalType
        switch goalType {
        case .time:
            self.text = "시간"
            self.icon = .timeIcon
        case .distance:
            self.text = "거리"
            self.icon = .distanceIcon
        }
    }
}
