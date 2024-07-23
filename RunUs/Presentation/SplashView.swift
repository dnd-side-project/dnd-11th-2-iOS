//
//  SplashView.swift
//  RunUs
//
//  Created by 최승용 on 7/22/24.
//

import SwiftUI

struct SplashView: View {
    @Binding var isLoading: Bool
    @State var loadingProgress: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 10) {
            Text("SplashView")
            HStack {
                Image(systemName: "1.circle")
                Image(systemName: "2.circle")
                Image(systemName: "3.circle")
            }
            .mask {
                GeometryReader { geometry in
                    Rectangle()
                        .frame(width: geometry.size.width * loadingProgress, height: geometry.size.height)
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                withAnimation {
                    loadingProgress += 0.1
                }
                if loadingProgress > 1.5 {
                    loadingProgress = 0
                }
            }
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                isLoading = false
            }
        }
    }
}

#Preview {
    SplashView(isLoading: .constant(true))
}
