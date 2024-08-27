//
//  HomeDependency.swift
//  RunUs
//
//  Created by seungyooooong on 8/28/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var homeAPI: HomeAPI {
        get { self[HomeAPIKey.self] }
        set { self[HomeAPIKey.self] = newValue }
    }
}

struct HomeAPIKey: DependencyKey {
    static var liveValue: HomeAPI = HomeAPILive()
    static var previewValue: HomeAPI = HomeAPIPreview()
}

