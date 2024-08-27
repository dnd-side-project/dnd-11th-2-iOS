//
//  RunningRecordResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 8/28/24.
//

import Foundation

struct RunningRecordResponseModel: Decodable, Equatable {
    var currentMonth: Int
    var currentKm: String
    var nextLevelName: String
    var nextLevelKm: String
    
    init() {
        self.currentMonth = 0
        self.currentKm = "0km"
        self.nextLevelName = "Level 0"
        self.nextLevelKm = "0km"
    }
    
    init(_ currentMonth: Int, _ currentKm: String, _ nextLevelName: String, _ nextLevelKm: String) {
        self.currentMonth = currentMonth
        self.currentKm = currentKm
        self.nextLevelName = nextLevelName
        self.nextLevelKm = nextLevelKm
    }
}

