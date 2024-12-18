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
    @StateObject private var viewEnvironment = ViewEnvironment()
    @StateObject private var loadingManager = LoadingManager.shared
    @StateObject private var alertManager = AlertManager.shared
    
    var body: some Scene {
        WindowGroup {
            runUsView
        }
    }
}

extension RunUsApp {
    private var runUsView: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            if isLoading { SplashView(isLoading: $isLoading) }
            else { MainView().environmentObject(viewEnvironment) }
            if loadingManager.isLoading { LoadingView() }
            if alertManager.isShowAlert { alertManager.ruAlert }
        }
        .onAppear{
            _ = LocationManager.shared
        }
    }
}
