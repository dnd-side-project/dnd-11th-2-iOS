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
//        if userEnvironment.isLogin { HomeView() }
        if userEnvironment.isLogin {
            RunAloneHomeView()
        }
        else {
            LoginView(
                store: Store(
                    initialState: LoginStore.State(userEnvironment: userEnvironment),
                    reducer: { LoginStore() }
                )
            )
        }
    }
}

#Preview {
    MainView().environmentObject(UserEnvironment())
}
