//
//  RunUsApp.swift
//  RunUs
//
//  Created by Ryeong on 7/19/24.
//

import SwiftUI

@main
struct RunUsApp: App {
    @State var isLoading: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.background.ignoresSafeArea()
                if isLoading { SplashView(isLoading: $isLoading) }
                else         { MainView().environmentObject(UserEnvironment()) } // 추후 네이밍 수정
            }
            .onAppear{
                _ = LocationManager.shared
            }
        }
    }
}
