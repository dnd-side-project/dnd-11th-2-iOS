//
//  WeatherParametersModel.swift
//  RunUs
//
//  Created by seungyooooong on 9/2/24.
//

import Foundation

class WeatherParametersModel {
    let address: String
    let longitude: Double
    let latitude: Double
    
    init(_ address: String, _ longitude: Double, _ latitude: Double) {
        self.address = address
        self.longitude = longitude
        self.latitude = latitude
    }
}
