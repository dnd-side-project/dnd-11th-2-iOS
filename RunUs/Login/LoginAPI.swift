//
//  LoginAPI.swift
//  RunUs
//
//  Created by seungyooooong on 8/21/24.
//

import Foundation
import AuthenticationServices

protocol LoginAPI {
    func appleLogin(authorization: ASAuthorization) async throws -> LoginResponseModel?
}

final class LoginAPILive: LoginAPI {
    func appleLogin(authorization: ASAuthorization) async throws -> LoginResponseModel? {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let fullName = appleIDCredential.fullName,
                  let idTokenData = appleIDCredential.identityToken,
                  let idToken = String(data: idTokenData, encoding: .utf8)
            else {
                throw NetworkError.unknown  // MARK: idToken을 제대로 받지 못한 에러
            }
            var name = ""
            
            if fullName.familyName == nil && fullName.givenName == nil {
                if appleIDCredential.email == nil { // MARK: .authorized case -> sign-in
                    let signInRequest = SignInRequestModel(socialType: "APPLE", idToken: idToken)
                    let result: LoginResponseModel = try await ServerNetwork.shared.request(.signIn(signInRequest: signInRequest))
                    return result
                } else {
                    throw NetworkError.unknown  // MARK: 이름을 제대로 받지 못한 에러
                }
            } else {    // MARK: familyName, givenName 둘 중 하나라도 값이 있는 경우 nil인 쪽을 공백으로 수정 후 진행
                name = (fullName.familyName ?? "") + (fullName.givenName ?? "")
            }
            
            // MARK: .notFound or .revorked case -> sign-up
            let signUpRequest = SignUpRequestModel(socialType: "APPLE", name: name, idToken: idToken)
            let result: LoginResponseModel = try await ServerNetwork.shared.request(.signUp(signUpRequest: signUpRequest))
            return result
        } else {
            return nil
        }
    }
}
