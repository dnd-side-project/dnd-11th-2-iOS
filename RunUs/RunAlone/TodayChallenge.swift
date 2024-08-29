//
//  TodayChallenge.swift
//  RunUs
//
//  Created by Ryeong on 8/8/24.
//

import Foundation

struct TodayChallenge: Equatable, Decodable {
    let challengeId: Int
    let title: String
    let expectedTime: String
    let icon: String
}

extension TodayChallenge: Identifiable {
    var id: Int { challengeId }
}
