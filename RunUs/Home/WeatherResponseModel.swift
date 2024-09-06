//
//  WeatherResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 8/27/24.
//

import Foundation

struct WeatherResponseModel: Decodable, Equatable {
    var weatherName: String
    var weatherDescription: String
    var weatherIconUrl: String
    var apparentTemperature: Int
    var minTemperature: Int
    var maxTemperature: Int
    
    init() {
        self.weatherName = ""
        self.weatherDescription = ""
        self.weatherIconUrl = ""
        self.apparentTemperature = 0
        self.minTemperature = 0
        self.maxTemperature = 0
    }
    
    init(_ weatherName: String, _ weatherDescription: String, _ weatherIconUrl: String, _ apparentTemperature: Int, _ maxTemperature: Int, _ minTemperature: Int) {
        self.weatherName = weatherName
        self.weatherDescription = weatherDescription
        self.weatherIconUrl = weatherIconUrl
        self.apparentTemperature = apparentTemperature
        self.minTemperature = minTemperature
        self.maxTemperature = maxTemperature
    }
}
