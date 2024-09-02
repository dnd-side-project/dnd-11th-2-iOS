//
//  LocationManager.swift
//  RunUs
//
//  Created by Ryeong on 8/5/24.
//

import Combine
import Foundation
import CoreLocation

enum LocationAuthorizationStatus {
    case agree
    case disagree
    case notyet
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var getWeatherPublisher = PassthroughSubject<WeatherParametersModel, Never>()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    var authorizationStatus: LocationAuthorizationStatus {
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted:
            return .notyet
        case .denied:
            return .disagree
        case .authorizedAlways, .authorizedWhenInUse:
            return .agree
        @unknown default:
            return .notyet
        }
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let location = self.locationManager.location else {
            // MARK: 사용자가 위치 접근 권한을 허용하지 않을 때, 기본 위치: 서울시 강남구
            return getWeatherPublisher.send(WeatherParametersModel("서울시 강남구", 127.0495556, 37.514575))
        }
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in  // TODO: 추후 Combine으로 수정
            var address = ""
            if let placemark = placemarks?.first {
                if let administrativeArea = placemark.administrativeArea {
                    address = administrativeArea
                }
                if let locality = placemark.locality {
                    address = address + " " + locality
                }
            }
            let longitude = location.coordinate.longitude
            let latitude = location.coordinate.latitude
            
            self.getWeatherPublisher.send(WeatherParametersModel(address, longitude, latitude))
        }
    }
}
