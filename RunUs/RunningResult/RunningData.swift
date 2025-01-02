//
//  RunningData.swift
//  RunUs
//
//  Created by Ryeong on 9/7/24.
//

import Foundation

struct RunningData: Encodable, Navigatable, Equatable {
    let runningTime: String
    let distanceMeter: Int
    let calorie: Int
    let route: [RURoute]
}
