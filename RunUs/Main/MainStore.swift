//
//  MainStore.swift
//  RunUs
//
//  Created by seungyooooong on 10/3/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MainStore {
    @ObservableState
    struct State {  // MARK: State
        var homeState = HomeStore.State()
        var runAloneState = RunAloneFeature.State()
        var myRecordState = MyRecordStore.State()
        
        var showLocationPermissionAlert: Bool = false
    }
    
    enum Action {   // MARK: Action
        // MARK: and so on
        case onAppear
        case checkLocationPermission
        case requestLocationPermission
        case showLocationPermissionAlert
        
        // MARK: getter
        case getChallenges
        case getWeather(WeatherParametersModel)
        case getMonthlySummary
        case getProfile
        case getBadges
        
        // MARK: setter
        case setChallenges(challenges: [TodayChallenge])
        case setWeather(weather: WeatherResponseModel)
        case setMonthlySummary(monthlySummary: MonthlySummaryResponseModel)
        case setProfile(profile: ProfileResponseModel)
        case setBadges(badges: [Badge])
        
        // MARK: refresh
        case homeRefresh
        case runAloneRefresh
        case myRecordRefresh
        
        // MARK: about scope
        case homeAction(HomeStore.Action)
        case runAloneAction(RunAloneFeature.Action)
        case myRecordAction(MyRecordStore.Action)
    }
    
    @Dependency(\.locationManager) var locationManager
    @Dependency(\.mainAPI) var mainAPI
    
    var body: some ReducerOf<Self> {    // MARK: Reducer
        Scope(state: \.homeState, action: \.homeAction) {
            HomeStore()
        }
        Scope(state: \.runAloneState, action: \.runAloneAction) {
            RunAloneFeature()
        }
        Scope(state: \.myRecordState, action: \.myRecordAction) {
            MyRecordStore()
        }
        Reduce { state, action in
            switch action {
                // MARK: and so on
            case .onAppear:
                return .run { send in
                    await send(.checkLocationPermission)
                    locationManager.sendGetWeatherPublisher()
                    await send(.getChallenges)
                    await send(.getMonthlySummary)
                    await send(.getProfile)
                    await send(.getBadges)
                }
            case .checkLocationPermission:
                let status = locationManager.authorizationStatus
                switch status {
                case .agree:
                    return .none
                case .disagree:
                    return .send(.showLocationPermissionAlert)
                case .notyet:
                    return .send(.requestLocationPermission)
                }
            case .requestLocationPermission:
                locationManager.requestLocationPermission()
                return .none
            case .showLocationPermissionAlert:
                AlertManager.shared.showAlert(title: Bundle.main.locationRequestDescription, mainButtonText: "설정", subButtonText: "취소", mainButtonAction: SystemManager.shared.openAppSetting)
                return .none
                
                // MARK: getter
            case .getChallenges:
                return .run { send in
                    await RUNetworkManager.task(
                        action: { try await mainAPI.getChallenges() },
                        successAction: { await send(.setChallenges(challenges: $0)) },
                        retryAction: { await send(.getChallenges) }
                    )
                }
            case let .getWeather(weatherParameters):
                return .run { send in
                    await RUNetworkManager.task(
                        action: { try await mainAPI.getWeathers(weatherParameters: weatherParameters) },
                        successAction: { await send(.setWeather(weather: $0)) },
                        retryAction: { await send(.getWeather(weatherParameters)) }
                    )
                }
            case .getMonthlySummary:
                return .run { send in
                    await RUNetworkManager.task(
                        action: { try await mainAPI.getMonthlySummary() },
                        successAction: { await send(.setMonthlySummary(monthlySummary: $0)) },
                        retryAction: { await send(.getMonthlySummary) }
                    )
                }
            case .getProfile:
                return .run { send in
                    await RUNetworkManager.task(
                        action: { try await mainAPI.getProfiles() },
                        successAction: { await send(.setProfile(profile: $0)) },
                        retryAction: { await send(.getProfile) }
                    )
                }
            case .getBadges:
                return .run { send in
                    await RUNetworkManager.task(
                        action: { try await mainAPI.getBadges() },
                        successAction: { await send(.setBadges(badges: $0)) },
                        retryAction: { await send(.getBadges) }
                    )
                }
                
                // MARK: setter
            case let .setChallenges(challenges):
                state.homeState.challenges = challenges
                state.runAloneState.challenges = challenges
                return .none
            case let .setWeather(weather):
                state.homeState.weather = weather
                return .none
            case let .setMonthlySummary(monthlySummary):
                state.homeState.monthlySummary = monthlySummary
                return .none
            case let .setProfile(profile):
                state.myRecordState.profile = profile
                return .none
            case let .setBadges(badges):
                state.myRecordState.badges = badges
                return .none
                
                // MARK: refresh
            case .homeRefresh:
                return .run { send in
                    await send(.getChallenges)
                    locationManager.sendGetWeatherPublisher()
                    await send(.getMonthlySummary)
                }
            case .runAloneRefresh:
                return .run { send in
                    await send(.getChallenges)
                }
            case .myRecordRefresh:
                return .run { send in
                    await send(.getProfile)
                    await send(.getBadges)
                }
                
                // MARK: about home scope
            case .homeAction(.mapGetWeatherPublisher):
                return .none
            case let .homeAction(.setAddress(weatherParameters)):
                return .send(.getWeather(weatherParameters))
            case .homeAction(.refresh):
                return .send(.homeRefresh)
            case let .homeAction(.selectChallenge(selectedChallengeIndex)):
                state.runAloneState.selectedChallengeIndex = selectedChallengeIndex
                return .none
            case let .homeAction(homeAction):
                return HomeStore().reduce(into: &state.homeState, action: homeAction)
                    .map(MainStore.Action.homeAction)
                
                // MARK: about runAlone scope
            case .runAloneAction(.onAppear(_)):
                return .none
            case .runAloneAction(.checkLocationPermission):
                return .send(.checkLocationPermission)
            case .runAloneAction(.selectGoal(_)):
                return .none
            case .runAloneAction(.startButtonTapped):
                return .none
            case let .runAloneAction(.selectChallenge(selectedChallengeIndex)):
                state.homeState.selectedChallengeIndex = selectedChallengeIndex
                return .none
            case let .runAloneAction(runAloneAction):
                return RunAloneFeature().reduce(into: &state.runAloneState, action: runAloneAction)
                    .map(MainStore.Action.runAloneAction)
                
                // MARK: about myRecord scope
            case .myRecordAction(.mapAuthorizationPublisher):
                return .none
            case .myRecordAction(.logout):
                return .none
            case .myRecordAction(.withdraw(_)):
                return .none
            case .myRecordAction(.appleLoginForWithdraw):
                return .none
            case let .myRecordAction(myRecordAction):
                return MyRecordStore().reduce(into: &state.myRecordState, action: myRecordAction)
                    .map(MainStore.Action.myRecordAction)
            }
        }
    }
}
