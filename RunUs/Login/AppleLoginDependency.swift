//
//  AppleLoginDependency.swift
//  RunUs
//
//  Created by seungyooooong on 8/7/24.
//

import Foundation
import Dependencies

extension DependencyValues {
    var appleLoginDependency: AppleLoginDependencyKey {
        get { self[AppleLoginDependencyKey.self] }
        set { self[AppleLoginDependencyKey.self] = newValue }
    }
}

struct AppleLoginDependencyKey {
    var fetch: (String, String, String) async throws -> ServerResponse<AppleLoginResponseModel>
}

extension AppleLoginDependencyKey: DependencyKey {
    static let liveValue = Self { name, email, IdToken in
        fetch: do {
            let serverResponse: ServerResponse<AppleLoginResponseModel> = ServerResponse(success: true, data: nil, error: nil)
            return serverResponse
        }
    }
}
