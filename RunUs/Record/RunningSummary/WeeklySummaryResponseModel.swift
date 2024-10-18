//
//  WeeklySummaryResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 10/10/24.
//

import Foundation

struct WeeklySummaryResponseModel: Decodable {
    var weeklyDate: String
    var weeklyValues: [ChartData]
    var lastWeekAvgValue: Double
    
    init() {
        self.weeklyDate = "20xx.xx.xx ~ 20xx.xx.xx"
        self.weeklyValues = [
            ChartData(day: "월", rating: 0),
            ChartData(day: "화", rating: 0),
            ChartData(day: "수", rating: 0),
            ChartData(day: "목", rating: 0),
            ChartData(day: "금", rating: 0),
            ChartData(day: "토", rating: 0),
            ChartData(day: "일", rating: 0)
        ]
        self.lastWeekAvgValue = 0
    }
    
    init(weeklyDate: String, weeklyValues: [ChartData], lastWeekAvgValue: Double) {
        self.weeklyDate = weeklyDate
        self.weeklyValues = weeklyValues
        self.lastWeekAvgValue = lastWeekAvgValue
    }
}

struct ChartData: Decodable {
    var day: String
    var rating: Double
}
