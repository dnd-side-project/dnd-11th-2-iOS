//
//  RunAloneDependency.swift
//  RunUs
//
//  Created by Ryeong on 8/5/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    
    var runAloneAPI: RunAloneAPI {
        get { self[RunAloneAPIKey.self] }
        set { self[RunAloneAPIKey.self] = newValue }
    }
}

struct RunAloneAPIKey: DependencyKey {
    static var liveValue: RunAloneAPI = RunAloneAPIImplements()
    static var previewValue: RunAloneAPI = RunAloneAPIMock()
}
