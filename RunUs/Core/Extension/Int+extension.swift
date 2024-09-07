//
//  Int+extension.swift
//  RunUs
//
//  Created by Ryeong on 8/17/24.
//

import Foundation

extension Int {
    func toTimeString() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = self % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
