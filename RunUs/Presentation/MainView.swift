//
//  MainView.swift
//  RunUs
//
//  Created by seungyooooong on 7/22/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var userEnvironment: UserEnvironment
    
    var body: some View {
        if userEnvironment.isLogin { HomeView() }
        else                       { LoginView() }
    }
}

#Preview {
    MainView()
}
