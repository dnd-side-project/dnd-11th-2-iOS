//
//  WithdrawResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

struct WithdrawResponseModel: Decodable {
    var isWithdrawSuccess: Bool
    
    init() {
        self.isWithdrawSuccess = true
    }
}
