//
//  UserEnvironment.swift
//  RunUs
//
//  Created by seungyooooong on 7/30/24.
//

import Foundation

class UserEnvironment: ObservableObject, Equatable {
    static func == (lhs: UserEnvironment, rhs: UserEnvironment) -> Bool {
        return lhs.isLogin == rhs.isLogin
    }
    
    @Published var isLogin: Bool = false
}
