//
//  RunningDependency.swift
//  RunUs
//
//  Created by Ryeong on 8/16/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var runningStateManager: RunningStateManager {
        get { self[RunningStateManagerKey.self] }
        set { self[RunningStateManagerKey.self] = newValue }
    }
}

struct RunningStateManagerKey: DependencyKey {
    static var liveValue: RunningStateManager = RunningStateManagerImplements()
}
