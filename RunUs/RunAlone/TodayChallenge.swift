//
//  TodayChallenge.swift
//  RunUs
//
//  Created by Ryeong on 8/8/24.
//

import Foundation

struct TodayChallenge: Equatable, Decodable, Identifiable {
    let id: Int
    let title: String
    let expectedTime: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id = "challengeId"
        case title
        case expectedTime
        case icon
    }
}
