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
    var totalMeter: String
    
    init() {
        self.totalCourses = 0
        self.totalMeter = "0km"
    }
    
    init(totalCourses: Int, totalMeter: String) {
        self.totalCourses = totalCourses
        self.totalMeter = totalMeter
    }
}

struct AchievedCourse: Decodable, Equatable {
    var name: String
    var meter: String
    var achievedAt: String
}

struct CurrentCourse: Decodable, Equatable {
    var name: String
    var totalMeter: String
    var achievedMeter: Int
    var message: String
    
    init() {
        self.name = "서울에서 인천"
        self.totalMeter = "31.2km"
        self.achievedMeter = 0
        self.message = "인천까지 31.2km 남았어요!"
    }
    
    init(name: String, totalMeter: String, achievedMeter: Int, message: String) {
        self.name = name
        self.totalMeter = totalMeter
        self.achievedMeter = achievedMeter
        self.message = message
    }
}
