//
//  MainView.swift
//  RunUs
//
//  Created by seungyooooong on 7/22/24.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    @EnvironmentObject var userEnvironment: UserEnvironment
    
    var body: some View {
        VStack {
            if userEnvironment.isLogin { HomeView() }
            else                       { LoginView(userEnvironment: userEnvironment) }
        }
    }
}

#Preview {
    MainView().environmentObject(UserEnvironment())
}
