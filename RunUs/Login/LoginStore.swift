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
    @ObservableState
    struct State: Equatable {}
    
    enum Action {
        case appleLoginRequest(ASAuthorizationAppleIDRequest)
        case appleLoginResult((Result<ASAuthorization, any Error>))
        
        case appleLoginResponse(LoginResponseModel?)
    }
    
    @Dependency(\.loginAPI) var loginAPI
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .appleLoginRequest(request):
            request.requestedScopes = [.fullName, .email]
            return .none
        case let .appleLoginResult(result):
            switch result {
            case .success(let authorization):
                return .run { send in
                    let response: LoginResponseModel? = try await loginAPI.appleLogin(authorization: authorization)
                    await send(.appleLoginResponse(response))
                }
            case .failure(_):
                return .none
            }
            
        case let .appleLoginResponse(response):
            guard let loginResponse: LoginResponseModel = response else {
                return .none
            }
            setUserDefaults(loginResponse: loginResponse)
            return .none
        }
    }
    
    private func setUserDefaults(loginResponse: LoginResponseModel) {
        UserDefaultManager.isLogin = true
        UserDefaultManager.name = loginResponse.nickname
        UserDefaultManager.email = loginResponse.email
        UserDefaultManager.accessToken = loginResponse.accessToken
        // TODO: 추후 refreshToken 추가
    }
}
