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
        var selectedChallengeIndex: Int = 0
        var challenges: [TodayChallenge] = []
        
        var currentLocatoin: String = ""
        var weather: WeatherResponseModel = WeatherResponseModel()
        
        var monthlySummary: MonthlySummaryResponseModel = MonthlySummaryResponseModel()
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case mapGetWeatherPublisher
        case setAddress(WeatherParametersModel)
        case refresh
        case selectChallenge(Int)
    }
    
    @Dependency(\.locationManager) var locationManager
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            case .mapGetWeatherPublisher:
                return Effect.publisher({
                    locationManager.getWeatherPublisher
                        .map { Action.setAddress($0) }
                        .receive(on: DispatchQueue.main)
                })
            case .refresh:
                return .none
            case let .setAddress(weatherParameters):
                state.currentLocatoin = weatherParameters.address
                return .none
            case let .selectChallenge(selectedChallengeIndex):
                state.selectedChallengeIndex = selectedChallengeIndex
                return .none
            }
        }
    }
}
