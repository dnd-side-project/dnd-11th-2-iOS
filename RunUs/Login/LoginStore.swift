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
        case failLogin
        
        case appleLoginRequest(ASAuthorizationAppleIDRequest)
        case appleLoginResult((Result<ASAuthorization, any Error>))
        
        case appleLoginResponse(ServerResponse<AppleLoginResponseModel>?)
    }
    
    @Dependency(\.appleLoginDependency) var appleLoginDependency
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .isLoginChanged(isLogin):
            state.userEnvironment.isLogin = isLogin
            return .none
        case .failLogin:
            // 로그인에 실패했을 때 처리
            print("Login is Failed")
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
                        await send(.failLogin)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                return .run { send in
                    await send(.failLogin)
                }
            }
            
        case let .appleLoginResponse(response):
            guard let response: ServerResponse<AppleLoginResponseModel> = response else {
                return .send(.failLogin)
            }
            guard let responseData: AppleLoginResponseModel = response.data else {
                return .send(.failLogin)
            }
            // accessToken를 어딘가에 넣어두고 계속 사용해야 함
            print("accessToken is \(responseData.accessToken)")
            return .send(.isLoginChanged(response.success))
        }
    }
}
