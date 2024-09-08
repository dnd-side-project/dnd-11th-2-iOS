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
                    switch viewEnvironment.selectedTabItem {
                    case .home:
                        HomeView()
                    case .running:
                        RunAloneHomeView()
                    case .myRecord:
                        MyRecordView()
                    }
                    RUTabBar()
                } else { LoginView() }
            }
            .ignoresSafeArea(.container, edges: .bottom)    // MARK: 홈버튼UI와 홈바UI에서 탭바를 동일하게 표현하기 위한 장치
        }
    }
}

#Preview {
    MainView()
}
