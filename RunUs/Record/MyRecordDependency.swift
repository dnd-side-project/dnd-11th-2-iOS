//
//  MyRecordDependency.swift
//  RunUs
//
//  Created by seungyooooong on 8/20/24.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var myRecordAPI: MyRecordAPI {
        get { self[MyRecordAPIKey.self] }
        set { self[MyRecordAPIKey.self] = newValue }
    }
}

struct MyRecordAPIKey: DependencyKey {
    static var liveValue: MyRecordAPI = MyRecordAPILive()
    static var previewValue: MyRecordAPI = MyRecordAPIPreview()
}
