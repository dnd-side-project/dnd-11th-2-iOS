//
//  LocationManager.swift
//  RunUs
//
//  Created by Ryeong on 8/5/24.
//

import Combine
import Foundation
import CoreLocation
import ComposableArchitecture
import Combine
import MapKit

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

final class LocationManager: NSObject {
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    private var stopLocation: CLLocation?
    
    var delegate: LocationManagerDelegate?
    var getWeatherPublisher = PassthroughSubject<WeatherParametersModel, Never>()
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = .fitness
//        locationManager.distanceFilter = 10   // TODO: 백그라운드에서만이라도 적용할지 고민중, 추후 배터리 타임 이슈 나오면 재조명
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
        stopLocation = locationManager.location
        locationManager.stopUpdatingLocation()
    }
    
    func getCurrentLocationCoordinator() -> CLLocationCoordinate2D {
        guard let location = self.locationManager.location else {
            return CLLocationCoordinate2D()
        }
        return location.coordinate
    }
}

extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // MARK: stop -> start 되자마자 받은 location은 무시 해야함
        if stopLocation == locations.last {
            return
        }
        if stopLocation != nil {
            delegate?.runningRestart(locations.last)
            stopLocation = nil
            return
        }
        delegate?.locationUpdated(locations.last)
    }
}

// MARK: delegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        sendGetWeatherPublisher()
    }
    
    func sendGetWeatherPublisher() {
        guard let location = self.locationManager.location else {
            // MARK: 사용자가 위치 접근 권한을 허용하지 않을 때, 기본 위치: 서울특별시 강남구
            return getWeatherPublisher.send(WeatherParametersModel("서울특별시 강남구", 127.0495556, 37.514575))
        }
        
        Task {
            let address = await getAddress()
            let longitude = location.coordinate.longitude
            let latitude = location.coordinate.latitude
            
            return getWeatherPublisher.send(WeatherParametersModel(address, longitude, latitude))
        }
    }
    
    func getAddress() async -> String {
        guard let location: CLLocation = self.locationManager.location else {
            return "서울특별시 강남구"
        }
        do {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
            var address = ""
            if let placemark = placemarks.first {
                if let administrativeArea = placemark.administrativeArea {
                    address = administrativeArea
                }
                if let locality = placemark.locality {
                    if address == locality {
                        if let subLocality = placemark.subLocality {
                            address = address + " " + subLocality
                        }
                    } else {
                        address = address + " " + locality
                    }
                }
            }
            return address
        } catch {
            return "서울특별시 강남구"
        }
    }
}
