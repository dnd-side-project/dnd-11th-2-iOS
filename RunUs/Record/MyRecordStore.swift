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
        case onAppear
        case mapAuthorizationPublisher
        
        case setProfile(profile: ProfileResponseModel)
        case setBadges(badges: [Badge])
        
        case logout
        case appleLoginForWithdraw
        case withdraw(withdrawRequest: WithdrawRequestModel)
    }
    
    @Dependency(\.myRecordAPI) var myRecordAPI
    @Dependency(\.authorizationManager) var authorizationManager
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                let profile = try await myRecordAPI.getProfiles()
                await send(.setProfile(profile: profile))
                let badges = try await myRecordAPI.getBadges()
                await send(.setBadges(badges: badges))
            }
        case .mapAuthorizationPublisher:
            return Effect.publisher({
                authorizationManager.authorizationPublisher
                    .map { Action.withdraw(withdrawRequest: $0) }
            })
        case let .setProfile(profile):
            state.profile.profileImageUrl = profile.profileImageUrl
            state.profile.currentKm = profile.currentKm
            state.profile.nextLevelName = profile.nextLevelName
            state.profile.nextLevelKm = profile.nextLevelKm
            return .none
        case let .setBadges(badges):
            state.badges = badges
            return .none
        case .logout:
            UserDefaultManager.isLogin = false
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
            return .run { _ in
                try await myRecordAPI.withdraw(withdrawRequest: withdrawRequest)
                UserDefaultManager.isLogin = false
                UserDefaultManager.name = nil
                UserDefaultManager.email = nil
                UserDefaultManager.accessToken = nil
            }
        }
    }
}
