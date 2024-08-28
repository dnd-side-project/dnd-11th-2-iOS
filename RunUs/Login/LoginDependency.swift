//
//  LoginDependency.swift
//  RunUs
//
//  Created by seungyooooong on 8/7/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var loginAPI: LoginAPI {
        get { self[LoginAPIKey.self] }
        set { self[LoginAPIKey.self] = newValue }
    }
}

struct LoginAPIKey: DependencyKey {
    static var liveValue: LoginAPI = LoginAPILive()
}
