//
//  AuthLoginRequestModel.swift
//  RunUs
//
//  Created by seungyooooong on 8/8/24.
//

import Foundation

struct AuthLoginRequestModel: Encodable {
    let socialType: String
    let idToken: String
    let email: String
    let nickName: String
    
    init(socialType: String, name: String, email: String, idToken: String) {
        self.socialType = socialType
        self.nickName = name
        self.email = email
        self.idToken = idToken
    }
}
