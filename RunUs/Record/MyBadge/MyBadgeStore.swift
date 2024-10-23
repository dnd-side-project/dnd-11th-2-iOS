//
//  MyBadgeStore.swift
//  RunUs
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation
import ComposableArchitecture

struct MyBadgeStore: Reducer {
    @ObservableState
    struct State: Equatable {
        var badgeLists: BadgeListsResponseModel = BadgeListsResponseModel()
    }
    
    enum Action {
        case onAppear
        case getBadgeLists
        case setBadgeLists(badgeLists: BadgeListsResponseModel)
    }
    
    @Dependency(\.myBadgeAPI) var myBadgeAPI
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                await send(.getBadgeLists)
            }
        case .getBadgeLists:
            return .run { send in
                let badgeLists = try await myBadgeAPI.getBadgeLists()
                await send(.setBadgeLists(badgeLists: badgeLists))
            }
        case let .setBadgeLists(badgeLists):
            state.badgeLists = badgeLists
            return .none
        }
    }
}
