//
//  LoginStore.swift
//  RunUs
//
//  Created by seungyooooong on 8/1/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct LoginStore: Reducer {
    struct State: Equatable {
        var userEnvironment: UserEnvironment
        var appleLoginManager: AppleLoginManager?
    }
    
    enum Action: Equatable {
        case setUserEnvironment(UserEnvironment)
        case isLoginChanged(Bool)
        case doAppleLogin(UIWindow?)
        case appleLoginResponse(Data)
    }
    
    @Dependency(\.loginDependency) var loginDependency
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .setUserEnvironment(userEnvironment):
            state.userEnvironment = userEnvironment
            return .none
        case let .isLoginChanged(isLogin):
            state.userEnvironment.isLogin = isLogin
            return .none
        case let .doAppleLogin(window):
            state.appleLoginManager = AppleLoginManager(window: window)
            state.appleLoginManager!.doAppleLogin()
            return .none
//            return .run { send in
//                let data = try await loginDependency.fetch()
//                await send(.appleLoginResponse(data))
//            }
        case let .appleLoginResponse(data):
            print(String(decoding: data, as: UTF8.self))
            return .send(.isLoginChanged(true))
        }
    }
}
