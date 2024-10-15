//
//  RunningSummaryStore.swift
//  RunUs
//
//  Created by seungyooooong on 10/10/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RunningSummaryStore {
    @ObservableState
    struct State {
        var distanceSummary: WeeklySummaryResponseModel = WeeklySummaryResponseModel()
        var timeSummary: WeeklySummaryResponseModel = WeeklySummaryResponseModel()
        
        func summary(for summaryType: SummaryTypes) -> WeeklySummaryResponseModel {
            switch summaryType {
            case .distance:
                return self.distanceSummary
            case .time:
                return self.timeSummary
            }
        }
    }
    
    enum Action {
        case onAppear
        case getWeeklySummary(summaryType: SummaryTypes)
        case setDistanceSummary(summary: WeeklySummaryResponseModel)
        case setTimeSummary(summary: WeeklySummaryResponseModel)
    }
    
    @Dependency(\.runningSummaryAPI) var runningSummaryAPI
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.getWeeklySummary(summaryType: .distance))
                    await send(.getWeeklySummary(summaryType: .time))
                }
            case .getWeeklySummary(let summaryType):
                return .run { send in
                    let summary = try await runningSummaryAPI.getWeeklySummary(summaryType: summaryType.rawValue)
                    if summaryType == .distance {
                        await send(.setDistanceSummary(summary: summary))
                    } else {
                        await send(.setTimeSummary(summary: summary))
                    }
                }
            case .setDistanceSummary(let summary):
                state.distanceSummary = summary
                return .none
            case .setTimeSummary(let summary):
                state.timeSummary = summary
                return .none
            }
        }
    }
}
