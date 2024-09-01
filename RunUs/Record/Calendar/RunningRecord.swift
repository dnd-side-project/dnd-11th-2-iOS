//
//  RunningRecord.swift
//  RunUs
//
//  Created by Ryeong on 9/1/24.
//

import Foundation

struct RunningRecord: Codable {
    var runningRecordId: Int
    var emoji: String
    var startLocation: String
    var endLocation: String
    var distanceMeter: Int
    var averagePace: String
    var calorie: Int
    
    init(runningRecordId: Int = 0,
         emoji: String = "",
         startLocation: String = "",
         endLocation: String = "",
         distanceMeter: Int = 0,
         averagePace: String = "",
         calorie: Int = 0) {
        self.runningRecordId = runningRecordId
        self.emoji = emoji
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.distanceMeter = distanceMeter
        self.averagePace = averagePace
        self.calorie = calorie
    }
}
