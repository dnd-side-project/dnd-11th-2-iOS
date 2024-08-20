//
//  MyRecordButton.swift
//  RunUs
//
//  Created by seungyooooong on 8/19/24.
//

import SwiftUI

struct MyRecordButton: View {
    let action: () -> Void
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
            Spacer()
            Image(.chevronRight)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.gray300)
                .frame(width: 24, height: 24)
        }
        .font(Fonts.pretendardBold(size: 16))
        .foregroundColor(.white)
        .frame(height: 60)
    }
}

#Preview {
    MyRecordButton(action: {}, text: "나의 뱃지")
        .background(Color.background)
}
