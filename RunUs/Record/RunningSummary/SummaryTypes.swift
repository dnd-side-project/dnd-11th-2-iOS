//
//  SummaryTypes.swift
//  RunUs
//
//  Created by seungyooooong on 10/10/24.
//

import Foundation

enum SummaryTypes: String {
    case distance = "DISTANCE"
    case time = "TIME"
    
    var labelString: String {
        switch self {
        case .distance:
            return "km"
        case .time:
            return "시간"
        }
    }
}
