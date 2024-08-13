//
//  RunUsApp.swift
//  RunUs
//
//  Created by Ryeong on 7/19/24.
//

import SwiftUI

@main
struct RunUsApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.background.ignoresSafeArea()
                RunUsTopView().environmentObject(UserEnvironment())
            }
        }
    }
}
