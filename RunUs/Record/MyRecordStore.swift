//
//  MyRecordStore.swift
//  RunUs
//
//  Created by seungyooooong on 8/20/24.
//

import ComposableArchitecture
import AuthenticationServices

struct MyRecordStore: Reducer {
    @ObservableState
    struct State: Equatable {
        var profile: ProfileResponseModel = ProfileResponseModel()
        var badges: [Badge] = []
        var appleLoginDelegate: AppleLoginDelegate? = nil
    }
    
    enum Action {
        case mapAuthorizationPublisher
        
        case logout
        case appleLoginForWithdraw
        case withdraw(withdrawRequest: WithdrawRequestModel)
    }
    
    @Dependency(\.myRecordAPI) var myRecordAPI
    @Dependency(\.authorizationManager) var authorizationManager
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .mapAuthorizationPublisher:
            return Effect.publisher({
                authorizationManager.authorizationPublisher
                    .map { Action.withdraw(withdrawRequest: $0) }
            })
        case .logout:
            UserDefaultManager.logout()
            return .none
        case .appleLoginForWithdraw:
            state.appleLoginDelegate = AppleLoginDelegate() { result in
                switch result {
                case .success(let credentials):
                    let withdrawRequest: WithdrawRequestModel = WithdrawRequestModel(socialType: "APPLE", authorizationCode: credentials.authorizationCode, idToken: credentials.idToken)
                    authorizationManager.authorizationPublisher.send(withdrawRequest)
                case .failure(_):
                    // MARK: 애플 로그인 실패 시 회원 탈퇴 진행 x
                    return
                }
            }
            
            let appleIdProvider = ASAuthorizationAppleIDProvider()
            let request = appleIdProvider.createRequest()
            let controller = ASAuthorizationController(authorizationRequests: [request])
            
            controller.delegate = state.appleLoginDelegate
            controller.performRequests()
            return .none
        case let .withdraw(withdrawRequest):
            return .run { send in
                await RUNetworkManager.task(
                    action: { try await myRecordAPI.withdraw(withdrawRequest: withdrawRequest) },
                    successAction: { if $0.isWithdrawSuccess { await send(.logout) } },
                    retryAction: { await send(.withdraw(withdrawRequest: withdrawRequest)) }
                )
            }
        }
    }
}
