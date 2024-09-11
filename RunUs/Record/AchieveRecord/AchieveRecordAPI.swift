//
//  AchieveRecordAPI.swift
//  RunUs
//
//  Created by seungyooooong on 9/5/24.
//

import Foundation

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
        var courses = CoursesResponseModel()
        courses.info = CourseInfo(totalCourses: 18, totalDistance: "43.800km")
        courses.achievedCourses = [AchievedCourse(name: "서울에서 인천", totalDistance: "31.2km", achievedAt: "2024. 08. 23.")]
        courses.currentCourse = CurrentCourse(name: "인천에서 대전", totalDistance: "141km", achievedDistance: "50m", message: "100km 남았어요!")
        return CoursesResponseModel(courses: courses)
    }
}
