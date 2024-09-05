//
//  AchieveRecordAPI.swift
//  RunUs
//
//  Created by seungyooooong on 9/5/24.
//

import Foundation

protocol AchieveRecordAPI {
    func getCourseSummary() async throws -> CourseSummaryResponseModel
}

final class AchieveRecordAPILive: AchieveRecordAPI {
    func getCourseSummary() async throws -> CourseSummaryResponseModel {
        let result: CourseSummaryResponseModel = try await ServerNetwork.shared.request(.getCourseSummary)
        return result
    }
}

final class AchieveRecordAPIPreview: AchieveRecordAPI {
    func getCourseSummary() async throws -> CourseSummaryResponseModel {
        return CourseSummaryResponseModel(courseCount: "18코스", runUsDistanceKm: "43.800km", earthDistanceKm: "40,075km")
    }
}
