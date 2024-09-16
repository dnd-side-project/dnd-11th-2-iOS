//
//  RunningResult.swift
//  RunUs
//
//  Created by Ryeong on 9/7/24.
//

import Foundation

struct RunningResult: Encodable, Navigatable {
    let startAt: String
    let endAt: String
    let startLocation: String
    let endLocation: String
    let emotion: String
    let challengeId: Int?
    let goalDistance: Int?
    let goalTime: Int?
    let achievementMode: String
    let runningData: RunningData
}


