//
//  SignUpRequestModel.swift
//  RunUs
//
//  Created by seungyooooong on 8/23/24.
//

import Foundation

struct SignUpRequestModel: Encodable {
    let socialType: String
    let idToken: String
    let nickname: String
    
    init(socialType: String, name: String, idToken: String) {
        self.socialType = socialType
        self.nickname = name
        self.idToken = idToken
    }
}

