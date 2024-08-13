//
//  LoginStore.swift
//  RunUs
//
//  Created by seungyooooong on 8/1/24.
//

import Foundation
import ComposableArchitecture
import AuthenticationServices

struct LoginStore: Reducer {
    struct State: Equatable {
        var userEnvironment: UserEnvironment
    }
    
    enum Action {
        case changeLoginStatus(isLogin: Bool, accessToken: String?)
        
        case appleLoginRequest(ASAuthorizationAppleIDRequest)
        case appleLoginResult((Result<ASAuthorization, any Error>))
        
        case appleLoginResponse(AppleLoginResponseModel?)
    }
    
    @Dependency(\.appleLoginDependency) var appleLoginDependency
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .changeLoginStatus(isLogin, accessToken):
            state.userEnvironment.isLogin = isLogin
            UserDefaultManager.accessToken = accessToken
            return .none
            
        case let .appleLoginRequest(request):
            request.requestedScopes = [.fullName, .email]
            return .none
        case let .appleLoginResult(result):
            switch result {
            case .success(let authorization):
                return .run { send in
                    do {
                        let response = try await appleLoginDependency.fetch(authorization)
                        await send(.appleLoginResponse(response))
                    } catch {
                        await send(.changeLoginStatus(isLogin: false, accessToken: nil))
                    }
                }
            case .failure(let error):
                return .send(.changeLoginStatus(isLogin: false, accessToken: nil))
            }
            
        case let .appleLoginResponse(response):
            guard let response: AppleLoginResponseModel = response else {
                return .send(.changeLoginStatus(isLogin: false, accessToken: nil))
            }
            return .send(.changeLoginStatus(isLogin: true, accessToken: response.accessToken))
        }
    }
}
