//
//  Date+extension.swift
//  RunUs
//
//  Created by Ryeong on 9/7/24.
//

import Foundation

extension Date {
    func formatStringHyphen() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
    func formatStringDot() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yy. MM. dd. a h:mm"
        return formatter.string(from: self)
    }
}
