//
//  AchieveRecordAPI.swift
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

protocol AchieveRecordAPI {
    func getCourses() async throws -> CoursesResponseModel
}

final class AchieveRecordAPILive: AchieveRecordAPI {
    func getCourses() async throws -> CoursesResponseModel {
        let result: CoursesResponseModel = try await ServerNetwork.shared.request(.getCourses)
        return result
    }
}

final class AchieveRecordAPIPreview: AchieveRecordAPI {
    func getCourses() async throws -> CoursesResponseModel {
        return CoursesResponseModel(courses: CoursesResponseModel())
    }
}
