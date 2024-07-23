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
            if isLoading { SplashView(isLoading: $isLoading) }
            else         { MainView() } // 추후 네이밍 수정
        }
    }
}
