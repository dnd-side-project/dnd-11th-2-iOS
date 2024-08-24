//
//  MyRecordStore.swift
//  RunUs
//
//  Created by seungyooooong on 8/20/24.
//

import Foundation
import ComposableArchitecture

struct MyRecordStore: Reducer {
    @ObservableState
    struct State: Equatable {
        var profile: ProfileResponseModel = ProfileResponseModel()
        var badges: [Badge] = []
    }
    
    enum Action {
        case onAppear
        case setProfile(profile: ProfileResponseModel)
        case setBadges(badges: [Badge])
    }
    
    @Dependency(\.myRecordAPI) var myRecordAPI
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                do {
                    let profile = try await myRecordAPI.getProfiles()
                    await send(.setProfile(profile: profile))
                    let badges = try await myRecordAPI.getBadges()
                    await send(.setBadges(badges: badges))
                } catch {
                    // TODO: API 에러났을 때 처리 시나리오 필요
                }
            }
        case let .setProfile(profile):
            state.profile.profileImageUrl = profile.profileImageUrl
            state.profile.currentKm = profile.currentKm
            state.profile.nextLevelName = profile.nextLevelName
            state.profile.nextLevelKm = profile.nextLevelKm
            return .none
        case let .setBadges(badges):
            state.badges = badges
            return .none
        }
    }
}
