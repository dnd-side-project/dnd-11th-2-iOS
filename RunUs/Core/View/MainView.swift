//
//  MainView.swift
//  RunUs
//
//  Created by seungyooooong on 7/22/24.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    @AppStorage(UserDefaultKey.isLogin.rawValue) var isLogin: Bool = false
    @AppStorage(UserDefaultKey.selectedTabItem.rawValue) var selectedTabItem: TabItems = .home
    
    var body: some View {
        VStack(spacing: 0) {
            if isLogin {
                switch selectedTabItem {
                case .home:
                    HomeView()
                case .running:
                    EmptyView() // TODO: RunAloneHomeView가 Navigation 이동인지, Tab 이동인지 확인 후 수정
                case .myRecord:
                    MyRecordView()
                }
                RUTabBar()
            } else { LoginView() }
        }
        .ignoresSafeArea(.container, edges: .bottom)    // MARK: 홈버튼UI와 홈바UI에서 탭바를 동일하게 표현하기 위한 장치
    }
}

#Preview {
    MainView()
}
