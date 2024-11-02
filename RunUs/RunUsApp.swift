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
    @StateObject private var alertEnvironment = AlertEnvironment()
    @StateObject private var viewEnvironment = ViewEnvironment()
    @StateObject private var loadingManager = LoadingManager.shared
    
    var body: some Scene {
        WindowGroup {
            runUsView.environmentObject(alertEnvironment)
        }
    }
}

extension RunUsApp {
    private var runUsView: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            if isLoading { SplashView(isLoading: $isLoading) }
            else { MainView().environmentObject(viewEnvironment) }
            if alertEnvironment.isShowAlert { alertEnvironment.ruAlert }
            if loadingManager.isLoading { LoadingView() }
        }
        .onAppear{
            _ = LocationManager.shared
        }
    }
}
