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
        var currentLocatoin: String = ""
        var weather: WeatherResponseModel = WeatherResponseModel()
        var challenges: [TodayChallenge] = []
        var monthlySummary: MonthlySummaryResponseModel = MonthlySummaryResponseModel()
    }
    
    enum Action {
        case onAppear
        case mapGetWeatherPublisher
        case requestLocationPermission
        
        case getWeather(WeatherParametersModel)
        case getChallenges
        case getMonthlySummary
        
        case setWeather(weather: WeatherResponseModel)
        case setChallenges(challenges: [TodayChallenge])
        case setMonthlySummary(monthlySummary: MonthlySummaryResponseModel)
    }
    
    @Dependency(\.locationManager) var locationManager
    @Dependency(\.homeAPI) var homeAPI
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                let status = locationManager.authorizationStatus
                switch status {
                case .agree:
                    break
                case .disagree:
//                    await send(.locationPermissionAlertChanged(true))
                    break   // TODO: locationPermissionAlert MainView로 옮기고 작업 수정
                case .notyet:
                    await send(.requestLocationPermission)
                }
                locationManager.sendGetWeatherPublisher()
                await send(.getChallenges)
                await send(.getMonthlySummary)
            }
        case .mapGetWeatherPublisher:
            return Effect.publisher({
                locationManager.getWeatherPublisher
                    .map { Action.getWeather($0) }
                    .receive(on: DispatchQueue.main)
            })
        case .requestLocationPermission:
            locationManager.requestLocationPermission()
            return .none
            
        case let .getWeather(weatherParameters):
            state.currentLocatoin = weatherParameters.address
            return .run { send in
                let weather = try await homeAPI.getWeathers(weatherParameters: weatherParameters)
                await send(.setWeather(weather: weather))
            }
        case .getChallenges:
            return .run { send in
                let challenges = try await homeAPI.getChallenges()
                await send(.setChallenges(challenges: challenges))
            }
        case .getMonthlySummary:
            return .run { send in
                let monthlySummary = try await homeAPI.getMonthlySummary()
                await send(.setMonthlySummary(monthlySummary: monthlySummary))
            }
            
        case let .setWeather(weather):
            state.weather = weather
            return .none
        case let .setChallenges(challenges):
            state.challenges = challenges
            return .none
        case let .setMonthlySummary(monthlySummary):
            state.monthlySummary = monthlySummary
            return .none
        }
    }
}
