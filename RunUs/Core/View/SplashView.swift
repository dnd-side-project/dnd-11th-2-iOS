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
            Image("SampleImage")  // 추후 변경
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .cornerRadius(20)
        }
        .onAppear {
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
