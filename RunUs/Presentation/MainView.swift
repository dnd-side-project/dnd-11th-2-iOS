//
//  MainView.swift
//  RunUs
//
//  Created by 최승용 on 7/22/24.
//

import SwiftUI

struct MainView: View {
    @State var isLogin: Bool = false
    
    var body: some View {
        if isLogin { HomeView() }
        else       { LoginView() }
    }
}

#Preview {
    MainView()
}