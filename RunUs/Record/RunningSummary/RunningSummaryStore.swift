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
        func isNoData() -> Bool {
            let distanceNoData = distanceSummary.weeklyValues.allSatisfy { $0.rating == 0 }
            let timeNoData = timeSummary.weeklyValues.allSatisfy { $0.rating == 0 }
            return distanceNoData && timeNoData
        }
    }
    
    enum Action {
        case onAppear
        case getWeeklySummary(summaryType: SummaryTypes)
        case setSummary(summaryType: SummaryTypes, summary: WeeklySummaryResponseModel)
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
                    await RUNetworkManager.task(
                        action: { try await runningSummaryAPI.getWeeklySummary(summaryType: summaryType.rawValue) },
                        successAction: { await send(.setSummary(summaryType: summaryType, summary: $0)) },
                        retryAction: { await send(.getWeeklySummary(summaryType: summaryType)) }
                    )
                }
            case .setSummary(let summaryType, let summary):
                switch summaryType {
                case .distance:
                    state.distanceSummary = summary
                case .time:
                    state.timeSummary = summary
                }
                return .none
            }
        }
    }
}
