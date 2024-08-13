//
//  CountDownView.swift
//  RunUs
//
//  Created by Ryeong on 8/13/24.
//

import SwiftUI

struct CountDownView: View {
    @Binding var isFinished: Bool
    @State private var count: Int = 3
    
    var body: some View {
        VStack {
            Text("\(count)")
                .font(Fonts.pretendardBlack(size: 84))
                .foregroundStyle(.mainGreen)
            //TODO: 런어스님 닉네임으로 변경
            Text("런어스님 오늘도 힘내세요!")
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
                self.isFinished = true
            }
        }
    }
}

#Preview {
    CountDownView(isFinished: .constant(false))
}
