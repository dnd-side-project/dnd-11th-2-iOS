//
//  SplashView.swift
//  RunUs
//
//  Created by seungyooooong on 7/22/24.
//

import SwiftUI

struct SplashView: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack {
            Image(.splash)
                .resizable()
                .scaledToFit()
                .frame(width: 79)
        }
        .onAppear {
            UserDefaultManager.selectedTabItem = TabItems.home.rawValue
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                isLoading = false
            }
        }
    }
}

#Preview {
    SplashView(isLoading: .constant(true))
        .background(Color.background)
}
