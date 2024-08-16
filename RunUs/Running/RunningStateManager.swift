//
//  RunningStateManager.swift
//  RunUs
//
//  Created by Ryeong on 8/16/24.
//

import Foundation
import Combine
import CoreLocation

protocol RunningStateManager {
    var timePublisher: PassthroughSubject<Int, Never> { get }
    var locationPublisher: PassthroughSubject<CLLocation?, Never> { get }
    func start()
    func pause()
}

class RunningStateManagerImplements: RunningStateManager {
    private var timer: Timer?
    
    private var time: Int = 0
    
    private(set) var timePublisher = PassthroughSubject<Int, Never>()
    private(set) var locationPublisher = PassthroughSubject<CLLocation?, Never>()
    
    init() {
        LocationManager.shared.delegate = self
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            self.time += 1
            self.timePublisher.send(self.time)
        })
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        LocationManager.shared.delegate = nil
    }
}

extension RunningStateManagerImplements: LocationManagerDelegate {
    func locationUpdated(_ location: CLLocation?) {
        self.locationPublisher.send(location)
    }
}
