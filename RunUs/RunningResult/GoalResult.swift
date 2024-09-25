//
//  GoalResult.swift
//  RunUs
//
//  Created by seungyooooong on 9/25/24.
//

import Foundation

struct GoalResult: Decodable {
    var title: String
    var subTitle: String
    var iconUrl: String
    var isSuccess: Bool
}
