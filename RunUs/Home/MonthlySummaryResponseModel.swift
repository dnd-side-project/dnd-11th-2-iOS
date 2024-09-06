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
    var nextLevelName: String
    var nextLevelKm: String
    
    init() {
        self.month = "0월"
        self.monthlyKm = "0km"
        self.nextLevelName = "Level 0"
        self.nextLevelKm = "0km"
    }
    
    init(_ month: String, _ monthlyKm: String, _ nextLevelName: String, _ nextLevelKm: String) {
        self.month = month
        self.monthlyKm = monthlyKm
        self.nextLevelName = nextLevelName
        self.nextLevelKm = nextLevelKm
    }
}

