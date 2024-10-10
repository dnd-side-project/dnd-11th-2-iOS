//
//  ChartData.swift
//  RunUs
//
//  Created by seungyooooong on 10/10/24.
//

import Foundation

struct ChartData: Identifiable {
    var id: String = UUID().uuidString
    var day: String
    var rating: Double
}
