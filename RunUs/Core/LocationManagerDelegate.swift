//
//  LocationManagerDelegate.swift
//  RunUs
//
//  Created by Ryeong on 8/17/24.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
    func locationUpdated(_ location: CLLocation?)
    func runningRestart(_ location: CLLocation?)
}
