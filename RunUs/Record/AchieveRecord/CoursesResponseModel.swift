//
//  CoursesResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 9/5/24.
//

import Foundation

struct CoursesResponseModel: Decodable, Equatable {
    var myAchievedStatus: MyAchievedStatus
    var info: CourseInfo
    var achievedCourses: [AchievedCourse]
    var currentCourse: Course
    var nextCourse: Course
    
    init() {
        self.myAchievedStatus = MyAchievedStatus()
        self.info = CourseInfo()
        self.achievedCourses = []
        self.currentCourse = Course()
        self.nextCourse = Course()
    }
    
    init(courses: CoursesResponseModel) {
        self.myAchievedStatus = courses.myAchievedStatus
        self.info = courses.info
        self.achievedCourses = courses.achievedCourses
        self.currentCourse = courses.currentCourse
        self.nextCourse = courses.nextCourse
    }
}

struct MyAchievedStatus: Decodable, Equatable {
    var achievedDistance: String
    var remainingTotalDistance: String
    var percentage: Double
    
    init() {
        self.achievedDistance = "0km"
        self.remainingTotalDistance = "완주까지 0km 남았어요!"
        self.percentage = 0
    }
    
    init(achievedDistance: String, remainingTotalDistance: String, percentage: Double) {
        self.achievedDistance = achievedDistance
        self.remainingTotalDistance = remainingTotalDistance
        self.percentage = percentage
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

struct Course: Decodable, Equatable {
    var name: String
    var totalDistance: String
    var message: String
    var courseOrder: Int
    
    init() {
        self.name = "서울에서 인천"
        self.totalDistance = "31.2km"
        self.message = "인천까지 31.2km 남았어요!"
        self.courseOrder = 0
    }
    
    init(name: String, totalDistance: String, message: String, courseOrder: Int) {
        self.name = name
        self.totalDistance = totalDistance
        self.message = message
        self.courseOrder = courseOrder
    }
}
