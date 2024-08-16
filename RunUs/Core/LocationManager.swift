//
//  LocationManager.swift
//  RunUs
//
//  Created by Ryeong on 8/5/24.
//

import Foundation
import CoreLocation
import ComposableArchitecture

extension DependencyValues {
    var locationManager: LocationManager {
        get { self[LocationManagerKey.self] }
        set { self[LocationManagerKey.self] = newValue }
    }
}

struct LocationManagerKey: DependencyKey {
    static let liveValue = LocationManager.shared
}

enum LocationAuthorizationStatus {
    case agree
    case disagree
    case notyet
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    
    var delegate: LocationManagerDelegate?
    
    private override init() {
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
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //TODO: stop -> start 되자마자 받은 location은 무시 해야함
        delegate?.locationUpdated(locations.last)
    }
}
