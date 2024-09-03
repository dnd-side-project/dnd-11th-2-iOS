//
//  SignInRequestModel.swift
//  RunUs
//
//  Created by seungyooooong on 8/23/24.
//

import Foundation

struct SignInRequestModel: Encodable {
    let socialType: String
    let idToken: String
    
    init(socialType: String, idToken: String) {
        self.socialType = socialType
        self.idToken = idToken
    }
}

