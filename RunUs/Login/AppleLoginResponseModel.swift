//
//  AppleLoginResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 8/7/24.
//

import Foundation

struct AppleLoginResponseModel: Decodable {
    let accessToken: String
    let refreshToken: String
}
