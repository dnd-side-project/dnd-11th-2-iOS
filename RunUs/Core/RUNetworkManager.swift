//
//  RUNetworkManager.swift
//  RunUs
//
//  Created by seungyooooong on 11/4/24.
//

import Foundation
import ComposableArchitecture

struct RUNetworkManager {
    static var retryCount: Int = 0  // MARK: 너무 많은 재시도를 막기 위한 임시 처리
    
    static func task<T>(
        action: @escaping () async throws -> T,
        successAction: @escaping (T) async -> Void,
        retryAction: @escaping () async -> Void
    ) async {
        do {
            let result = try await action()
            await successAction(result)
        } catch {   // TODO: 추후 세분화
            await withCheckedContinuation { continuation in
                AlertManager.shared.showNetworkAlert {
                    retryCount += 1
                    if retryCount > 5 { SystemManager.shared.terminateApp() }
                    else { Task { await retryAction() } }
                    continuation.resume()
                }
            }
        }
    }
}
