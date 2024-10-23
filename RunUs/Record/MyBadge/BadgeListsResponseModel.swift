//
//  BadgeListsResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

struct BadgeListsResponseModel: Decodable, Equatable {
    var recencyBadges: [Badge]
    var personalBadges: [Badge]
    var distanceBadges: [Badge]
    var streakBadges: [Badge]
    var durationBadges: [Badge]
    var levelBadges: [Badge]
    
    init() {
        self.recencyBadges = []
        self.personalBadges = []
        self.distanceBadges = []
        self.streakBadges = []
        self.durationBadges = []
        self.levelBadges = []
    }
    
    init(badgeLists: BadgeListsResponseModel) {
        self.recencyBadges = badgeLists.recencyBadges
        self.personalBadges = badgeLists.personalBadges
        self.distanceBadges = badgeLists.distanceBadges
        self.streakBadges = badgeLists.streakBadges
        self.durationBadges = badgeLists.durationBadges
        self.levelBadges = badgeLists.levelBadges
    }
}

