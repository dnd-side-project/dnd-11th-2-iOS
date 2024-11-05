//
//  MainView.swift
//  RunUs
//
//  Created by seungyooooong on 7/22/24.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    @EnvironmentObject var alertEnvironment: AlertEnvironment
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @AppStorage(UserDefaultKey.isLogin.rawValue) var isLogin: Bool = false
    @State var store: StoreOf<MainStore> = Store(
        initialState: MainStore.State(),
        reducer: { MainStore() }
    )
    
    var body: some View {
        NavigationStack(path: $viewEnvironment.navigationPath) {
            Group {
                if isLogin {
                    VStack(spacing: 0) {
                        ZStack {    // MARK: challenge image 요청 수 때문에 ZStack으로 롤백
                            HomeView(
                                store: store.scope(
                                    state: \.homeState,
                                    action: \.homeAction
                                )
                            ).opacity(viewEnvironment.selectedTabItem == .home ? 1 : 0)
                            RunAloneView(
                                store: store.scope(
                                    state: \.runAloneState,
                                    action: \.runAloneAction
                                )
                            ).opacity(viewEnvironment.selectedTabItem == .running ? 1 : 0)
                            MyRecordView(
                                store: store.scope(
                                    state: \.myRecordState,
                                    action: \.myRecordAction
                                )
                            ).opacity(viewEnvironment.selectedTabItem == .myRecord ? 1 : 0)
                        }
                        RUTabBar(store: store)
                    }
                    .onAppear {
                        store.send(.onAppear)
                    }
                    .onChange(of: viewEnvironment.selectedTabItem) { oldValue, newValue in
                        switch newValue {
                        case .home:
                            store.send(.homeRefresh)
                        case .running:
                            store.send(.runAloneRefresh)
                        case .myRecord:
                            store.send(.myRecordRefresh)
                        }
                    }
                    .onChange(of: store.showLocationPermissionAlert) { oldValue, newValue in
                        if newValue {
                            alertEnvironment.showAlert(title: Bundle.main.locationString, mainButtonText: "설정", subButtonText: "취소", mainButtonAction: SystemManager.shared.openAppSetting, subButtonAction: self.subButtonAction)
                        }
                    }
                } else { LoginView() }
            }
            .ignoresSafeArea(.container, edges: .bottom)    // MARK: 홈버튼UI와 홈바UI에서 탭바를 동일하게 표현하기 위한 장치
            .background(Color.background)
            .onChange(of: isLogin) { oldValue, newValue in  // MARK: logout & withdraw 완료 후 viewEnvironment 초기화
                if !newValue {
                    viewEnvironment.reset()
                }
            }
            .navigationDestination(for: NavigationObject.self) { navigationObject in
                Group {
                    switch navigationObject.viewType {
                    case .setGoal:
                        let goalType = navigationObject.data as! GoalTypes
                        SetGoalView(goalType)
                    case .running:
                        let runningStartInfo = navigationObject.data as! RunningStartInfo
                        RunningView(runningStartInfo)
                    case .runningResult:
                        let runningResult = navigationObject.data as! RunningResult
                        RunningResultView(runningResult: runningResult)
                    case .recordResult:
                        let runningRecord = navigationObject.data as! RunningRecord
                        RunningResultView(runningRecord: runningRecord)
                    case .runningRecord:
                        RunningRecordView()
                    case .runningSummary:
                        RunningSummaryView()
                    case .achieveRecord:
                        let profile = navigationObject.data as! ProfileResponseModel
                        AchieveRecordView(profile: profile)
                    case .myBadge:
                        MyBadgeView()
                    }
                }
                .navigationBarHidden(true)
                .if(navigationObject.viewType.navigationType == .home) { view in
                    view.blockDismissGesture()
                }
            }
        }
    }
    
    private func subButtonAction() {
        store.send(.locationPermissionAlertChanged(false))
        alertEnvironment.dismiss()
    }
}

#Preview {
    MainView()
        .environmentObject(ViewEnvironment())
}
