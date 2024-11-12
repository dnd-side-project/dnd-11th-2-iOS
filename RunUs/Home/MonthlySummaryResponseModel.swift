//
//  MonthlySummaryResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 8/28/24.
//

import Foundation

struct MonthlySummaryResponseModel: Decodable, Equatable {
    var month: String
    var monthlyKm: String
    var message: String
    var startName: String
    var endName: String
    var percentage: Double
    
    init() {
        self.month = "0월"
        self.monthlyKm = "0km"
        self.message = "OO까지 00km 남았어요!"
        self.startName = "OO"
        self.endName = "OO"
        self.percentage = 0
    }
    
    init(_ month: String, _ monthlyKm: String, _ message: String, _ startName: String, _ endName: String, _ percentage: Double) {
        self.month = month
        self.monthlyKm = monthlyKm
        self.message = message
        self.startName = startName
        self.endName = endName
        self.percentage = percentage
    }
}

