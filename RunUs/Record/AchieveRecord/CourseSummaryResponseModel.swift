//
//  CourseSummaryResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 9/5/24.
//

import Foundation

struct CourseSummaryResponseModel: Decodable, Equatable {
    var courseCount: String
    var runUsDistanceKm: String
    var earthDistanceKm: String
    
    init() {
        self.courseCount = "0코스"
        self.runUsDistanceKm = "0km"
        self.earthDistanceKm = "40,075km"
    }
    
    init(courseCount: String, runUsDistanceKm: String, earthDistanceKm: String) {
        self.courseCount = courseCount
        self.runUsDistanceKm = runUsDistanceKm
        self.earthDistanceKm = earthDistanceKm
    }
}
