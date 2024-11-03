//
//  LoadingView.swift
//  RunUs
//
//  Created by seungyooooong on 11/2/24.
//

import SwiftUI

struct LoadingView: View {
    @State var isShowLoading = false
    @State var timer: Timer?
    
    var body: some View {
        ProgressView()
            .opacity(isShowLoading ? 1 : 0)
            .frame(maxWidth:. infinity, maxHeight: .infinity)
            .background(Color.background.opacity(isShowLoading ? 0.5 : 0.01))
            .onAppear {
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                    isShowLoading = true
                }
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
                isShowLoading = false
            }
    }
}

#Preview {
    LoadingView()
}
