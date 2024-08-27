//
//  WeatherResponseModel.swift
//  RunUs
//
//  Created by seungyooooong on 8/27/24.
//

import Foundation

struct WeatherResponseModel: Decodable, Equatable {
    var imageUrl: String
    var title: String
    var caption: String
    var sensoryTemperature: Int
    var maximumTemperature: Int
    var minimumTemperature: Int
    
    init() {
        self.imageUrl = ""
        self.title = "" // TODO: default 문구 추가
        self.caption = "" // TODO: default 문구 추가
        self.sensoryTemperature = 0
        self.maximumTemperature = 0
        self.minimumTemperature = 0
    }
    
    init(_ imageUrl: String, _ title: String, _ caption: String, _ sensoryTemperature: Int, _ maximumTemperature: Int, _ minimumTemperature: Int) {
        self.imageUrl = imageUrl
        self.title = title
        self.caption = caption
        self.sensoryTemperature = sensoryTemperature
        self.maximumTemperature = maximumTemperature
        self.minimumTemperature = minimumTemperature
    }
}
