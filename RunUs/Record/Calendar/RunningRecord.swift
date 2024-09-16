//
//  RunningRecord.swift
//  RunUs
//
//  Created by Ryeong on 9/1/24.
//

import Foundation

struct RunningRecordResponse: Codable {
    let records: [RunningRecord]
}

struct RunningRecord: Codable, Identifiable {
    var id: Int {
        return runningRecordId
    }
    var runningRecordId: Int
    var emoji: Emotions
    var startLocation: String
    var endLocation: String
    var distanceMeter: Int
    var averagePace: String
    var calorie: Int
    var duration: String
    
    init(runningRecordId: Int = 0,
         emotion: Emotions = .veryGood,
         startLocation: String = "",
         endLocation: String = "",
         distanceMeter: Int = 0,
         averagePace: String = "",
         calorie: Int = 0,
         duration: String = "") {
        self.runningRecordId = runningRecordId
        self.emoji = emotion
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.distanceMeter = distanceMeter
        self.averagePace = averagePace
        self.calorie = calorie
        self.duration = duration
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.runningRecordId = try container.decode(Int.self, forKey: .runningRecordId)
        self.emoji = try container.decode(Emotions.self, forKey: .emoji)
        self.startLocation = try container.decode(String.self, forKey: .startLocation)
        self.endLocation = try container.decode(String.self, forKey: .endLocation)
        self.distanceMeter = try container.decode(Int.self, forKey: .distanceMeter)
        self.averagePace = try container.decode(String.self, forKey: .averagePace)
        self.calorie = try container.decode(Int.self, forKey: .calorie)
        self.duration = try container.decode(String.self, forKey: .duration)
    }
}
