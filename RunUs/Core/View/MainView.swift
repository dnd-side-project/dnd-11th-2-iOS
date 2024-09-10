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
                    ZStack {    // TODO: 추후 LazyHStack을 사용하거나.. 더 좋은 방법으로 수정
                        HomeView()
                            .opacity(viewEnvironment.selectedTabItem == .home ? 1 : 0)
                        RunAloneHomeView()
                            .opacity(viewEnvironment.selectedTabItem == .running ? 1 : 0)
                        MyRecordView()
                            .opacity(viewEnvironment.selectedTabItem == .myRecord ? 1 : 0)
                    }
                    RUTabBar()
                } else { LoginView() }
            }
            .ignoresSafeArea(.container, edges: .bottom)    // MARK: 홈버튼UI와 홈바UI에서 탭바를 동일하게 표현하기 위한 장치
            .onChange(of: isLogin) { oldValue, newValue in  // MARK: logout & withdraw 완료 후 viewEnvironment 초기화
                if !newValue {
                    viewEnvironment.selectedTabItem = .home
                }
            }
        }
    }
}

#Preview {
    MainView()
}
