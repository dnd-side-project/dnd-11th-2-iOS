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
        case isLoginChanged(Bool)
        
        case appleLoginRequest(ASAuthorizationAppleIDRequest)
        case appleLoginResult((Result<ASAuthorization, any Error>))
        
        case appleLoginResponse(ServerResponse<AppleLoginResponseModel>)
    }
    
    @Dependency(\.appleLoginDependency) var appleLoginDependency
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .isLoginChanged(isLogin):
            state.userEnvironment.isLogin = isLogin
            return .none
            
        case let .appleLoginRequest(request):
            request.requestedScopes = [.fullName, .email]
            return .none
        case let .appleLoginResult(result):
            switch result {
            case .success(let authorization):
                if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                    let fullName = appleIDCredential.fullName
                    let name =  (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                    let email = appleIDCredential.email ?? ""
                    let IdToken = String(data: appleIDCredential.identityToken!, encoding: .utf8) ?? ""
                    
                    return .run { send in
                        let response = try await appleLoginDependency.fetch(name, email, IdToken)
                        await send(.appleLoginResponse(response))
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                print("error")
            }
            return .none
            
        case let .appleLoginResponse(response):
            print("AppleLoginResponse is \(response)")
            return .send(.isLoginChanged(response.success))
        }
    }
}
