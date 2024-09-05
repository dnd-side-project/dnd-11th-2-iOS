//
//  AchieveRecordDependency.swift
//  RunUs
//
//  Created by seungyooooong on 9/5/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var achieveRecordAPI: AchieveRecordAPI {
        get { self[AchieveRecordAPIKey.self] }
        set { self[AchieveRecordAPIKey.self] = newValue }
    }
}

struct AchieveRecordAPIKey: DependencyKey {
    static var liveValue: AchieveRecordAPI = AchieveRecordAPILive()
    static var previewValue: AchieveRecordAPI = AchieveRecordAPIPreview()
}

