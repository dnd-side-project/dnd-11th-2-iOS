//
//  AppleLoginRequestModel.swift
//  RunUs
//
//  Created by seungyooooong on 8/8/24.
//

import Foundation

struct AppleLoginRequestModel: Encodable {
    let socialType: String
    let idToken: String
    let email: String
    let nickName: String
    
    init(name: String, email: String, idToken: String) {
        self.socialType = "APPLE"
        self.nickName = name
        self.email = email
        self.idToken = idToken
    }
}
