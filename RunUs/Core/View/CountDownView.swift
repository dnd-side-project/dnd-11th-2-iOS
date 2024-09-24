//
//  CountDownView.swift
//  RunUs
//
//  Created by Ryeong on 8/13/24.
//

import SwiftUI

struct CountDownView: View {
    @Binding var isReady: Bool
    @State private var count: Int = 3
    @AppStorage(UserDefaultKey.name.rawValue) var userName: String = "런어스"
    
    var body: some View {
        VStack {
            Text("\(count)")
                .font(Fonts.pretendardBlack(size: 84))
                .foregroundStyle(.mainGreen)
            Text("\(userName)님 오늘도 힘내세요!")
                .font(Fonts.pretendardMedium(size: 18))
                .foregroundStyle(.white)
        }
        .onAppear{
            startCountdown()
    }
}
    
    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.count > 1 {
                self.count -= 1
            } else {
                timer.invalidate()
                self.isReady = true
            }
        }
    }
}

#Preview {
    CountDownView(isReady: .constant(false))
}
