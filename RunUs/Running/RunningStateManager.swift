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
    func stop()
}

class RunningStateManagerImplements: RunningStateManager {
    private var timer: DispatchSourceTimer?
    private var time: Int = 0
    
    private(set) var timePublisher = PassthroughSubject<Int, Never>()
    private(set) var locationPublisher = PassthroughSubject<CLLocation?, Never>()
    private(set) var restartPublisher = PassthroughSubject<CLLocation?, Never>()
    
    init() {
        LocationManager.shared.delegate = self
    }
    
    func start() {
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer?.schedule(deadline: .now() + .seconds(1), repeating: .seconds(1))
        timer?.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.time += 1
                self?.timePublisher.send(self?.time ?? 0)
            }
        }
        timer?.resume()
        
        LocationManager.shared.startUpdatingLocation()
    }
    
    func pause() {
        timer?.cancel()
        timer = nil
        LocationManager.shared.stopUpdatingLocation()
    }
    
    func stop() {
        self.time = 0
        self.pause()
    }
    
    deinit {
        stop()
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

enum RunningState {
    case running
    case pause
    case stop
}
