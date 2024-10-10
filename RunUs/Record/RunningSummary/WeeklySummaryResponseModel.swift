//
//  WeeklySummaryResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 10/10/24.
//

import Foundation

struct WeeklySummaryResponseModel: Decodable {
    var date: String
    var weeklyValues: [Double]
    var lastWeekAvgValue: Double
    
    init() {
        self.date = "20xx.xx.xx ~ 20xx.xx.xx"
        self.weeklyValues = [0, 0, 0, 0, 0, 0, 0]
        self.lastWeekAvgValue = 0
    }
    
    init(date: String, weeklyValues: [Double], lastWeekAvgValue: Double) {
        self.date = date
        self.weeklyValues = weeklyValues
        self.lastWeekAvgValue = lastWeekAvgValue
    }
}
