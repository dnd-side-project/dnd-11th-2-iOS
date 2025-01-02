//
//  RURoute.swift
//  RunUs
//
//  Created by seungyooooong on 12/26/24.
//

import Foundation

struct RURoute: Codable, Navigatable {
    let start: RUCoordinates
    let end: RUCoordinates
}

struct RUCoordinates: Codable, Navigatable {
    let latitude: Double
    let longitude: Double
}

