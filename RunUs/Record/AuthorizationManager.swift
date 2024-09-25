//
//  AuthorizationManager.swift
//  RunUs
//
//  Created by seungyooooong on 8/22/24.
//

import Combine
import Foundation
import AuthenticationServices
import ComposableArchitecture

extension DependencyValues {
    var authorizationManager: AuthorizationManager {
        get { self[AuthorizationManagerKey.self] }
        set { self[AuthorizationManagerKey.self] = newValue }
    }
}

struct AuthorizationManagerKey: DependencyKey {
    static var liveValue: AuthorizationManager = AuthorizationManagerLive()
}

protocol AuthorizationManager {
    var authorizationPublisher: PassthroughSubject<WithdrawRequestModel, Never> { get }
}

final class AuthorizationManagerLive: AuthorizationManager {
    var authorizationPublisher = PassthroughSubject<WithdrawRequestModel, Never>()
}

final class AppleLoginDelegate: NSObject, ASAuthorizationControllerDelegate {
    let completion: (Result<(authorizationCode: String, idToken: String), Error>) -> Void
    
    init(completion: @escaping (Result<(authorizationCode: String, idToken: String), Error>) -> Void) {
        self.completion = completion
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let authorizationCodeData = appleIDCredential.authorizationCode,
           let identityTokenData = appleIDCredential.identityToken,
           let authorizationCode = String(data: authorizationCodeData, encoding: .utf8),
           let identityToken = String(data: identityTokenData, encoding: .utf8) {
            completion(.success((authorizationCode: authorizationCode, idToken: identityToken)))
        } else {
            completion(.failure(NetworkError.unknown))
        }
    }
        
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion(.failure(error))
    }
}

