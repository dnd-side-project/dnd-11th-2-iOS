//
//  MyBadgeAPI.swift
//  RunUs
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var myBadgeAPI: MyBadgeAPI {
        get { self[MyBadgeAPIKey.self] }
        set { self[MyBadgeAPIKey.self] = newValue }
    }
}

struct MyBadgeAPIKey: DependencyKey {
    static var liveValue: MyBadgeAPI = MyBadgeAPILive()
    static var previewValue: MyBadgeAPI = MyBadgeAPIPreview()
}

protocol MyBadgeAPI {
    func getBadgeLists() async throws -> BadgeListsResponseModel
}

final class MyBadgeAPILive: MyBadgeAPI {
    func getBadgeLists() async throws -> BadgeListsResponseModel {
        let result: BadgeListsResponseModel = try await ServerNetwork.shared.request(.getBadgeLists)
        return result
    }
}

final class MyBadgeAPIPreview: MyBadgeAPI {
    func getBadgeLists() async throws -> BadgeListsResponseModel {
        return BadgeListsResponseModel(badgeLists: BadgeListsResponseModel())
    }
}

