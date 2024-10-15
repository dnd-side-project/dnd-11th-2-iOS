//
//  RunningStateManager.swift
//  RunUs
//
//  Created by Ryeong on 8/16/24.
//

import Foundation
import Combine
import CoreLocation
import ComposableArchitecture

extension DependencyValues {
    var runningStateManager: RunningStateManager {
        get { self[RunningStateManagerKey.self] }
        set { self[RunningStateManagerKey.self] = newValue }
    }
}

struct RunningStateManagerKey: DependencyKey {
    static var liveValue: RunningStateManager = RunningStateManagerImplements()
}

protocol RunningStateManager {
    var timePublisher: PassthroughSubject<Int, Never> { get }
    var locationPublisher: PassthroughSubject<CLLocation?, Never> { get }
    var restartPublisher: PassthroughSubject<CLLocation?, Never> { get }
    func start()
    func pause()
}

class RunningStateManagerImplements: RunningStateManager {
    private var timer: Timer?
    
    private var time: Int = 0
    
    private(set) var timePublisher = PassthroughSubject<Int, Never>()
    private(set) var locationPublisher = PassthroughSubject<CLLocation?, Never>()
    private(set) var restartPublisher = PassthroughSubject<CLLocation?, Never>()
    
    init() {
        LocationManager.shared.delegate = self
    }
    
    func start() {
        self.timePublisher.send(self.time)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            self.time += 1
            self.timePublisher.send(self.time)
        })
        LocationManager.shared.startUpdatingLocation()
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        LocationManager.shared.stopUpdatingLocation()
    }
    
    deinit {
        pause()
        LocationManager.shared.delegate = nil
    }
}

extension RunningStateManagerImplements: LocationManagerDelegate {
    func locationUpdated(_ location: CLLocation?) {
        self.locationPublisher.send(location)
    }
    func runningRestart(_ location: CLLocation?) {
        self.restartPublisher.send(location)
    }
}
