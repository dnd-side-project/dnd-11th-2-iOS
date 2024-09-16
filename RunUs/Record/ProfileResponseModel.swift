//
//  ProfileResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 8/20/24.
//

import Foundation

struct ProfileResponseModel: Decodable, Equatable, Navigatable {
    var profileImageUrl: String
    var currentLevelName: String
    var currentKm: String
    var nextLevelName: String
    var nextLevelKm: String
    
    init() {
        self.profileImageUrl = ""
        self.currentLevelName = "Level 0"
        self.currentKm = "0km"
        self.nextLevelName = "Level 0"
        self.nextLevelKm = "0Km"
    }
    
    init(_ profileImageUrl: String, _ currentLevelName: String, _ currentKm: String, _ nextLevelName: String, _ nextLevelKm: String) {
        self.profileImageUrl = profileImageUrl
        self.currentLevelName = currentLevelName
        self.currentKm = currentKm
        self.nextLevelName = nextLevelName
        self.nextLevelKm = nextLevelKm
    }
}
