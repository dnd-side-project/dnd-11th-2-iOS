//
//  DateFormatter+extension.swift
//  RunUs
//
//  Created by Ryeong on 9/1/24.
//

import Foundation

extension DateFormatter {
    static let yyyyMM_kr: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        return formatter
    }()
    
    static let yyyyMM_dot: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM."
        return formatter
    }()
}
