//
//  BadgeListsResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

struct BadgeListsResponseModel: Decodable, Equatable, Hashable {
    var recencyBadges: [Badge]
    var badgesList: [BadgeList]
    
    init() {
        self.recencyBadges = []
        self.badgesList = []
    }
    
    init(badgeLists: BadgeListsResponseModel) {
        self.recencyBadges = badgeLists.recencyBadges
        self.badgesList = badgeLists.badgesList
    }
}

struct BadgeList: Decodable, Equatable, Hashable {
    var category: String
    var badges: [Badge]
}

