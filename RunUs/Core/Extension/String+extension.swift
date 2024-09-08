//
//  String+extension.swift
//  RunUs
//
//  Created by seungyooooong on 8/18/24.
//

import Foundation

extension String {
    public var formatToKM: String {
        switch self.count {
        case 1:
            return "00" + self
        case 2:
            if self.hasSuffix("0") {
                return "0" + String(self.dropLast())
            } else {
                return "0" + self
            }
        case 3:
            if self.hasSuffix("00") {
                return String(self.dropLast(2))
            } else if self.hasSuffix("0") {
                return String(self.dropLast())
            } else {
                return self
            }
        default:
            return self
        }
    }
    
    func formatDateHyphen() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self) ?? Date()
    }
    
    func formatDateDot() -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yy. MM. dd. a h:mm"
        return formatter.date(from: self) ?? Date()
    }
    
}
