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
        self.currentKm = ""
        self.nextLevelName = ""
        self.nextLevelKm = ""
    }
    
    init(_ profileImageUrl: String, _ currentKm: String, _ nextLevelName: String, _ nextLevelKm: String) {
        self.profileImageUrl = profileImageUrl
        self.currentKm = currentKm
        self.nextLevelName = nextLevelName
        self.nextLevelKm = nextLevelKm
    }
}
