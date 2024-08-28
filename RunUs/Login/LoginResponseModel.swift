//
//  LoginResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 8/7/24.
//

import Foundation

struct LoginResponseModel: Decodable {
    let nickname: String
    let email: String
    let accessToken: String
    let refreshToken: String
}
