//
//  ViewEnvironment.swift
//  RunUs
//
//  Created by seungyooooong on 9/3/24.
//

import Foundation

class ViewEnvironment: ObservableObject {
    @Published var selectedTabItem: TabItems = .home
    @Published var selectedRunningMode: RunningMode = .normal
    @Published var selectedChallengeIndex: Int = .zero
    @Published var navigationPath: [NavigationObject] = []
    
    func reset() {
        self.selectedTabItem = .home
        self.selectedRunningMode = .normal
        self.selectedChallengeIndex = .zero
        self.navigationPath = []
    }
}

protocol Navigatable: Hashable {}

struct NavigationObject: Navigatable {
    let viewType: ViewTypes
    let data: AnyHashable?
    
    init(viewType: ViewTypes, data: AnyHashable? = nil) {
        self.viewType = viewType
        self.data = data
    }
}

enum ViewTypes {
    case setGoal
    case running
    case runningResult
    case recordCalendar
    case achieveRecord
}
