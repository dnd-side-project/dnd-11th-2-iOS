//
//  MainView.swift
//  RunUs
//
//  Created by seungyooooong on 7/22/24.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @AppStorage(UserDefaultKey.isLogin.rawValue) var isLogin: Bool = false
    
    var body: some View {
        NavigationStack(path: $viewEnvironment.navigationPath) {
            VStack(spacing: 0) {
                if isLogin {
                    TabView(selection: $viewEnvironment.selectedTabItem) {
                        HomeView().tag(TabItems.home)
                        RunAloneView().tag(TabItems.running)
                        MyRecordView().tag(TabItems.myRecord)
                    }
                    RUTabBar()
                } else { LoginView() }
            }
            .ignoresSafeArea(.container, edges: .bottom)    // MARK: 홈버튼UI와 홈바UI에서 탭바를 동일하게 표현하기 위한 장치
            .background(Color.background)
            .onAppear {
                UITabBar.appearance().isHidden = true   // MARK: 기본 TabBar를 숨김
            }
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
                    }
                }
                .navigationBarHidden(true)  // MARK: iOS 18 이후 NavigationStack + Map UI에서 나타나는 NavigationBar 영역을 지우기 위해 필요
                .if(navigationObject.viewType.navigationType == .back) { view in
                    view.dismissGesture(viewEnvironment: viewEnvironment)
                }
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(ViewEnvironment())
}
