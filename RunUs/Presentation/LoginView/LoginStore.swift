//
//  LoginStore.swift
//  RunUs
//
//  Created by seungyooooong on 8/1/24.
//

import Foundation
import ComposableArchitecture

struct LoginStore: Reducer {
    struct State: Equatable {
        static func == (lhs: LoginStore.State, rhs: LoginStore.State) -> Bool {
            return lhs.isLogin == rhs.isLogin
        }
        
        var userEnvironment: UserEnvironment
        var isLogin: Bool {
            get {
                return userEnvironment.isLogin
            }
            set(newValue) {
                userEnvironment.isLogin = newValue
            }
        }
    }
    
    enum Action: Equatable {
        case doAppleLogin
        case appleLoginResponse(Data)
    }
    
    @Dependency(\.loginDependency) var loginDependency
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .doAppleLogin:
            return .run { send in
                let data = try await loginDependency.fetch()
                await send(.appleLoginResponse(data))
            }
        case let .appleLoginResponse(data):
            print(String(decoding: data, as: UTF8.self))
            state.isLogin = true
            return .none
        }
    }

}
