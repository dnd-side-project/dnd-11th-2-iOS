//
//  RUNetworkManager.swift
//  RunUs
//
//  Created by seungyooooong on 11/4/24.
//

import Foundation
import ComposableArchitecture

struct RUNetworkManager {
    static func task<T>(
        action: @escaping () async throws -> T,
        successAction: @escaping (T) async -> Void,
        retryAction: @escaping () async -> Void
    ) async {
        do {
            let result = try await action()
            await successAction(result)
        } catch let error as NetworkError {
            if error.isLoginError {
                UserDefaultManager.logout()
                AlertManager.shared.showAlert(title: "런어스 서비스 이용을 위해서는\n회원 가입이 필요합니다.", isSingleButtonAlert: true)
            } else {
                await showNetworkAlert(retryAction)
            }
        } catch {   // MARK: 정상적으로 ServerNetwork를 통해 통신하는 경우 여기로 걸리지 않기 때문에 자세한 확인이 필요
            print("Wrong error is occured, error is \(error)")
            await showNetworkAlert(retryAction)
        }
    }
    
    private static func showNetworkAlert(_ retryAction: @escaping () async -> Void) async {
        await withCheckedContinuation { continuation in
            AlertManager.shared.showNetworkAlert {
                Task {
                    await retryAction()
                    continuation.resume()
                }
            }
        }
    }
}
