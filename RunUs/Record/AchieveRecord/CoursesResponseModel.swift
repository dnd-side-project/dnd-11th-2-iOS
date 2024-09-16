//
//  CoursesResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 9/5/24.
//

import Foundation

struct CoursesResponseModel: Decodable, Equatable {
    var info: CourseInfo
    var achievedCourses: [AchievedCourse]
    var currentCourse: CurrentCourse
    
    init() {
        self.info = CourseInfo()
        self.achievedCourses = []
        self.currentCourse = CurrentCourse()
    }
    
    init(courses: CoursesResponseModel) {
        self.info = courses.info
        self.achievedCourses = courses.achievedCourses
        self.currentCourse = courses.currentCourse
    }
}

struct CourseInfo: Decodable, Equatable {
    var totalCourses: Int
    var totalDistance: String
    
    init() {
        self.totalCourses = 0
        self.totalDistance = "0km"
    }
    
    init(totalCourses: Int, totalDistance: String) {
        self.totalCourses = totalCourses
        self.totalDistance = totalDistance
    }
}

struct AchievedCourse: Decodable, Equatable {
    var name: String
    var totalDistance: String
    var achievedAt: String
}

struct CurrentCourse: Decodable, Equatable {
    var name: String
    var totalDistance: String
    var achievedDistance: String
    var message: String
    
    init() {
        self.name = "서울에서 인천"
        self.totalDistance = "31.2km"
        self.achievedDistance = "0m"
        self.message = "인천까지 31.2km 남았어요!"
    }
    
    init(name: String, totalDistance: String, achievedDistance: String, message: String) {
        self.name = name
        self.totalDistance = totalDistance
        self.achievedDistance = achievedDistance
        self.message = message
    }
}
