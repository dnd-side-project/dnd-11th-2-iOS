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
    var isSelected: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "challengeId"
        case title
        case expectedTime
        case icon
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.expectedTime = try container.decode(String.self, forKey: .expectedTime)
        self.icon = try container.decode(String.self, forKey: .icon)
        self.isSelected = false
    }
    
    init(id: Int, title: String, expectedTime: String, icon: String, isSelected: Bool = false) {
        self.id = id
        self.title = title
        self.expectedTime = expectedTime
        self.icon = icon
        self.isSelected = isSelected
    }
}
