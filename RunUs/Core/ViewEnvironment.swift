//
//  ViewEnvironment.swift
//  RunUs
//
//  Created by seungyooooong on 9/3/24.
//

import Foundation

class ViewEnvironment: ObservableObject {
    @Published var selectedTabItem: TabItems = .home
    @Published var navigationPath: [String] = []
    
    func reset() {
        self.selectedTabItem = .home
        self.navigationPath = []
    }
}
