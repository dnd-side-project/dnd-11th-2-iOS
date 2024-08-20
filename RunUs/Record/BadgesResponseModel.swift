//
//  BadgesResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 8/20/24.
//

import Foundation

struct BadgesResponseModel: Decodable {
    var badgeId: Int = 0
    var name: String = "testName"
    var imageUrl: String = ""
    var achieveAt: String = ""
}
