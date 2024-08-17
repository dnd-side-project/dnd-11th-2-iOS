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
    
    var body: some View {
        VStack {
            if isLogin { HomeView() }
            else { LoginView() }
        }
    }
}

#Preview {
    MainView()
}
