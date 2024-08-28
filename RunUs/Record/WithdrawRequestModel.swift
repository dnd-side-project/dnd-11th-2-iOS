//
//  WithdrawRequestModel.swift
//  RunUs
//
//  Created by seungyooooong on 8/21/24.
//

import Foundation

struct WithdrawRequestModel: Encodable {
    let socialType: String
    let authorizationCode: String
    let idToken: String
    
    init(socialType: String, authorizationCode: String, idToken: String) {
        self.socialType = socialType
        self.authorizationCode = authorizationCode
        self.idToken = idToken
    }
}
