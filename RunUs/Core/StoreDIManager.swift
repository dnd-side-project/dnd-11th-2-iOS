//
//  StoreDIManager.swift
//  RunUs
//
//  Created by Ryeong on 8/5/24.
//

import Foundation
import ComposableArchitecture

struct StoreDIManager {
    static var runAloneHome: StoreOf<RunAloneHomeFeature> {
        let store = Store(initialState: RunAloneHomeFeature.State(),
                          reducer: { RunAloneHomeFeature()
                .dependency(\.locationManager, LocationManager())
        })
        return store
    }
}
