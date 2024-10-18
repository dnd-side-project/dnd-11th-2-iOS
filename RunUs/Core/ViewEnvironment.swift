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
    @Published var navigationPath: [NavigationObject] = []
    
    func reset() {
        self.selectedTabItem = .home
        self.selectedRunningMode = .normal
        self.navigationPath = []
    }
    
    func navigate(_ navigationObject: NavigationObject) {
        if let currentPath = self.navigationPath.last {
            if currentPath.viewType == navigationObject.viewType { return }
        }
        self.navigationPath.append(navigationObject)
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
    case recordResult
    case runningRecord
    case runningSummary
    case achieveRecord
    
    var navigationType: NavigationButtonType {
        switch self {
        case .running, .runningResult:
            return .home
        default:
            return .back
        }
    }
}
