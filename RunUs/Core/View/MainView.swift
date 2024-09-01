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
        NavigationStack {   // TODO: EnvironmentObject로 path 추가할지 여부와 selectedTabItem을 EnvironmentObject에 넣을지 논의 후 수정
            VStack(spacing: 0) {
                if isLogin {
                    switch selectedTabItem {
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
