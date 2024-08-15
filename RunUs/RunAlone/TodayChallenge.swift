//
//  TodayChallenge.swift
//  RunUs
//
//  Created by Ryeong on 8/8/24.
//

import Foundation

struct TodayChallenge: Equatable, Decodable, Identifiable {
    let id: Int
    let imageUrl: String
    let title: String
    let estimatedMinute: Int
    var isSelected: Bool
}
