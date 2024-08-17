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
                guard let fullName = appleIDCredential.fullName,
                      let email = appleIDCredential.email,
                      let identiTyToken = appleIDCredential.identityToken,
                      let idToken = String(data: identiTyToken, encoding: .utf8)
                else {
                    throw NetworkError.unknown
                }
                
                var name = ""
                if fullName.familyName == nil && fullName.givenName == nil {
                    throw NetworkError.unknown
                } else {
                    name = (fullName.familyName ?? "") + (fullName.givenName ?? "")
                }
                
                let appleLoginRequest = AuthLoginRequestModel(socialType: "APPLE", name: name, email: email, idToken: idToken)
                let result: AppleLoginResponseModel = try await ServerNetwork.shared.request(.appleLogin(appleLoginRequest: appleLoginRequest))
                UserDefaultManager.name = name
                UserDefaultManager.email = email
                return result
            } else {
                return nil
            }
        }
    }
}
