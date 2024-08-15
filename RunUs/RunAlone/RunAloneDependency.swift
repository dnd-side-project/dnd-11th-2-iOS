//
//  RunAloneDependency.swift
//  RunUs
//
//  Created by Ryeong on 8/5/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var locationManager: LocationManager {
        get { self[LocationManagerKey.self] }
        set { self[LocationManagerKey.self] = newValue }
    }
    
    var runAloneAPI: RunAloneAPI {
        get { self[RunAloneAPIKey.self] }
        set { self[RunAloneAPIKey.self] = newValue }
    }
}

struct LocationManagerKey: DependencyKey {
    static let liveValue = LocationManager()
}

struct RunAloneAPIKey: DependencyKey {
    static var liveValue: RunAloneAPI = RunAloneAPIImplements()
    static var previewValue: RunAloneAPI = RunAloneAPIMock()
}
