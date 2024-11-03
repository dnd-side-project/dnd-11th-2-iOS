//
//  LoadingManager.swift
//  RunUs
//
//  Created by seungyooooong on 11/2/24.
//

import Foundation

class LoadingManager: ObservableObject {
    static let shared = LoadingManager()
    private init() { }
    
    private var loadingCount = 0
    @Published private(set) var isLoading = false
    
    func startLoading() {
        DispatchQueue.main.async {
            self.loadingCount += 1
            self.isLoading = true
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.loadingCount -= 1
            if self.loadingCount <= 0 {
                self.loadingCount = 0
                self.isLoading = false
            }
        }
    }
}
