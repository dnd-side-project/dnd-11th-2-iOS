//
//  LoginDependency.swift
//  RunUs
//
//  Created by seungyooooong on 8/2/24.
//

import Foundation
import Dependencies

extension DependencyValues {
    var loginDependency: LoginDependencyKey {
        get { self[LoginDependencyKey.self] }
        set { self[LoginDependencyKey.self] = newValue }
    }
}

struct LoginDependencyKey {
    var fetch: () async throws -> Data
}

extension LoginDependencyKey: DependencyKey {
    static let liveValue = Self {
        fetch: do {
            let (data, _) = try await URLSession.shared.data(
                from: URL(string: "https://api.runus.site/api/v1/examples/data")!
            )
            return data
        }
    }
}
