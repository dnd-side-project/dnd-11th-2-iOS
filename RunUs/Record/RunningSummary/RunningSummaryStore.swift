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
        var distanceChartDatas: [ChartData] = [
            ChartData(day: "월", rating: 0),
            ChartData(day: "화", rating: 0),
            ChartData(day: "수", rating: 0),
            ChartData(day: "목", rating: 0),
            ChartData(day: "금", rating: 0),
            ChartData(day: "토", rating: 0),
            ChartData(day: "일", rating: 0)
            ]
        var timeChartDatas: [ChartData] = [
            ChartData(day: "월", rating: 0),
            ChartData(day: "화", rating: 0),
            ChartData(day: "수", rating: 0),
            ChartData(day: "목", rating: 0),
            ChartData(day: "금", rating: 0),
            ChartData(day: "토", rating: 0),
            ChartData(day: "일", rating: 0)
            ]
        
        func summary(for summaryType: SummaryTypes) -> WeeklySummaryResponseModel {
            switch summaryType {
            case .distance:
                return self.distanceSummary
            case .time:
                return self.timeSummary
            }
        }
        
        func chartDatas(for summaryType: SummaryTypes) -> [ChartData] {
            switch summaryType {
            case .distance:
                return self.distanceChartDatas
            case .time:
                return self.timeChartDatas
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
                for index in 0 ..< state.distanceChartDatas.count {
                    state.distanceChartDatas[index].rating = summary.weeklyValues[index]
                }
                return .none
            case .setTimeSummary(let summary):
                state.timeSummary = summary
                for index in 0 ..< state.timeChartDatas.count {
                    state.timeChartDatas[index].rating = summary.weeklyValues[index]
                }
                return .none
            }
        }
    }
}
