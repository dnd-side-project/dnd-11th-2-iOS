//
//  LocationManager.swift
//  RunUs
//
//  Created by Ryeong on 8/5/24.
//

import Foundation
import CoreLocation

enum LocationAuthorizationStatus {
    case agree
    case disagree
    case notyet
}

final class LocationManager {
    private let locationManager = CLLocationManager()
    
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
}
