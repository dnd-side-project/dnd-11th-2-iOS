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
        GeometryReader { geometry in
            VStack {
                Image("SampleImage")  // 추후 변경
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .cornerRadius(20)
                    .foregroundColor(.white)    // 추후 삭제
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
        .background(Color("BackgroundColor"))
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                isLoading = false
            }
        }
    }
}

#Preview {
    SplashView(isLoading: .constant(true))
}
