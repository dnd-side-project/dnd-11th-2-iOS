//
//  Double+extension.swift
//  RunUs
//
//  Created by seungyooooong on 10/16/24.
//

import Foundation

extension Double {
    var mDistanceFormat: String {
        let m = floor(self / 10)
        return String(format: "%.2f", m / 100)
    }
    var kmDistanceFormat: String {
        let km = floor(self * 100)
        return String(format: "%.2f", km / 100)
    }
}
