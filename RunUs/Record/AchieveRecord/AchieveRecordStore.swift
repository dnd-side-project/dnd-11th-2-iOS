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
        var courseSummary: CourseSummaryResponseModel = CourseSummaryResponseModel()
    }
    
    enum Action {
        case onAppear
        case getCourseSummary
        case setCourseSummary(courseSummary: CourseSummaryResponseModel)
    }
    
    @Dependency(\.achieveRecordAPI) var achieveRecordAPI
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                await send(.getCourseSummary)
            }
        case .getCourseSummary:
            return .run { send in
                let courseSummary = try await achieveRecordAPI.getCourseSummary()
                await send(.setCourseSummary(courseSummary: courseSummary))
            }
        case let .setCourseSummary(courseSummary):
            state.courseSummary = courseSummary
            return .none
        }
    }
}
