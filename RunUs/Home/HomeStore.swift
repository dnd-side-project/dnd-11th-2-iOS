//
//  HomeStore.swift
//  RunUs
//
//  Created by seungyooooong on 8/27/24.
//

import Foundation
import ComposableArchitecture

struct HomeStore: Reducer {
    @ObservableState
    struct State: Equatable {
        var weather: WeatherResponseModel = WeatherResponseModel()
        var challenges: [TodayChallenge] = []
        var runningRecord: RunningRecordResponseModel = RunningRecordResponseModel()
    }
    
    enum Action {
        case onAppear
        case setWeather(weather: WeatherResponseModel)
        case setChallenges(challenges: [TodayChallenge])
        case setRunningRecord(runningRecord: RunningRecordResponseModel)
    }
    
    @Dependency(\.homeAPI) var homeAPI
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                do {
                    let weather = try await homeAPI.getWeathers()
                    await send(.setWeather(weather: weather))
                    let challenges = try await homeAPI.getChallenges()
                    await send(.setChallenges(challenges: challenges))
                    let runningRecord = try await homeAPI.getRunningRecord()
                    await send(.setRunningRecord(runningRecord: runningRecord))
                } catch {
                    // TODO: API 에러났을 때 처리 시나리오 필요
                }
            }
        case let .setWeather(weather):
            state.weather = weather
            return .none
        case let .setChallenges(challenges):
            state.challenges = challenges
            return .none
        case let .setRunningRecord(runningRecord):
            state.runningRecord = runningRecord
            return .none
        }
    }
}
