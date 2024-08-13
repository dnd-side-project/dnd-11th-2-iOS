//
//  AppleLoginDependency.swift
//  RunUs
//
//  Created by seungyooooong on 8/7/24.
//

import Foundation
import Dependencies
import AuthenticationServices

extension DependencyValues {
    var appleLoginDependency: AppleLoginDependencyKey {
        get { self[AppleLoginDependencyKey.self] }
        set { self[AppleLoginDependencyKey.self] = newValue }
    }
}

struct AppleLoginDependencyKey {
    var fetch: (ASAuthorization) async throws -> AppleLoginResponseModel?
}

extension AppleLoginDependencyKey: DependencyKey {
    static let liveValue = Self { authorization in
        fetch: do {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let fullName = appleIDCredential.fullName
                let name =  (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                let email = appleIDCredential.email ?? ""
                let idToken = String(data: appleIDCredential.identityToken!, encoding: .utf8) ?? ""
                
                let appleLoginRequest = AppleLoginRequestModel(name: name, email: email, idToken: idToken)
                let result: AppleLoginResponseModel = try await ServerNetwork.shared.request(.appleLogin(appleLoginRequest: appleLoginRequest))
                return result
            } else {
                return nil
            }
        }
    }
}
