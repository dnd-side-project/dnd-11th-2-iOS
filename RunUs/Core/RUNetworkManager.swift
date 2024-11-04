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
        } catch {   // TODO: 추후 세분화
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
}
