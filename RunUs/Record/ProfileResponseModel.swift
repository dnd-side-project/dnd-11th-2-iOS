//
//  ProfileResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 8/20/24.
//

import Foundation

struct ProfileResponseModel: Decodable, Equatable {
    var profileImageUrl: String
    var currentKm: String
    var nextLevelName: String
    var nextLevelKm: String
    
    init() {
        self.profileImageUrl = ""
        self.currentKm = "0km"
        self.nextLevelName = "Level 0"
        self.nextLevelKm = "0Km"
    }
    
    init(_ profileImageUrl: String, _ currentKm: String, _ nextLevelName: String, _ nextLevelKm: String) {
        self.profileImageUrl = profileImageUrl
        self.currentKm = currentKm
        self.nextLevelName = nextLevelName
        self.nextLevelKm = nextLevelKm
    }
}
