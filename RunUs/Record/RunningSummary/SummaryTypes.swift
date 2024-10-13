//
//  SummaryTypes.swift
//  RunUs
//
//  Created by seungyooooong on 10/10/24.
//

import Foundation
import SwiftUI

enum SummaryTypes: String {
    case distance = "DISTANCE"
    case time = "TIME"
    
    var titleString: String {
        switch self {
        case .distance:
            return "KM"
        case .time:
            return "시간"
        }
    }
    
    var labelString: String {
        switch self {
        case .distance:
            return "km"
        case .time:
            return "시간"
        }
    }
    
    var chartColor: Color {
        switch self {
        case .distance:
            return .mainGreen
        case .time:
            return .mainBlue
        }
    }
}
