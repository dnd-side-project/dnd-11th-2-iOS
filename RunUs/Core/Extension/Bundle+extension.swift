//
//  Bundle+extension.swift
//  RunUs
//
//  Created by Ryeong on 8/5/24.
//

import Foundation

extension Bundle {
    var locationRequestDescription: String {
        return object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") as? String ?? "위치 설정 필요"
    }
}
