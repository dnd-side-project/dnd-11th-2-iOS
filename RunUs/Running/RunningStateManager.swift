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
    var kcalPublisher: PassthroughSubject<Int, Never> { get }
    func start()
    func pause()
}

class RunningStateManagerImplements: RunningStateManager {
    
    private var timer: Timer?
    
    private var time: Int = 0
    private var kcal: Float = 0
    
    private(set) var timePublisher = PassthroughSubject<Int, Never>()
    private(set) var locationPublisher = PassthroughSubject<CLLocation?, Never>()
    private(set) var kcalPublisher = PassthroughSubject<Int, Never>()
    
    init() {
        LocationManager.shared.delegate = self
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            self.time += 1
            self.timePublisher.send(self.time)
            
            // 1분에 약 10kcal 소모
            self.kcal += 0.16
            self.kcalPublisher.send(Int(self.kcal))
        })
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
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
}
