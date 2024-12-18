//
//  AchieveRecordStore.swift
//  RunUs
//
//  Created by seungyooooong on 9/5/24.
//

import Foundation
import ComposableArchitecture

struct AchieveRecordStore: Reducer {
    @ObservableState
    struct State: Equatable {
        var courses: CoursesResponseModel = CoursesResponseModel()
    }
    
    enum Action {
        case onAppear
        case getCourses
        case setCourses(courses: CoursesResponseModel)
    }
    
    @Dependency(\.achieveRecordAPI) var achieveRecordAPI
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                await send(.getCourses)
            }
        case .getCourses:
            return .run { send in
                await RUNetworkManager.task(
                    action: { try await achieveRecordAPI.getCourses() },
                    successAction: { await send(.setCourses(courses: $0)) },
                    retryAction: { await send(.getCourses) }
                )
            }
        case let .setCourses(courses):
            state.courses = courses
            return .none
        }
    }
}
