//
//  BadgesResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 8/20/24.
//

import Foundation

struct BadgesResponseModel: Decodable {
    let badges: [Badge]
}

struct Badge: Decodable, Equatable, Hashable {
    var badgeId: Int = 0
    var name: String = ""
    var imageUrl: String = ""
    var achievedAt: String = ""
}
