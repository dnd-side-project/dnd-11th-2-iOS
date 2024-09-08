//
//  Int+extension.swift
//  RunUs
//
//  Created by Ryeong on 8/17/24.
//

import Foundation

extension Int {
    func toTimeString() -> String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
