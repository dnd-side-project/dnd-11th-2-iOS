//
//  RUTitle.swift
//  RunUs
//
//  Created by seungyooooong on 10/7/24.
//

import SwiftUI

struct RUTitle: View {
    let text: String
    var textSize: CGFloat = 16
    
    var body: some View {
        ruTitle(text: text, textSize: textSize, isButton: false)
    }
}
    // TODO: 추후 RUTitle & RUTitleButton 통합
struct RUTitleButton: View {
    let action: () -> Void
    let text: String
    var textSize: CGFloat = 16
    
    var body: some View {
        Button {
            action()
        } label: {
            ruTitle(text: text, textSize: textSize, isButton: true)
        }
    }
}

private func ruTitle(text: String, textSize: CGFloat, isButton: Bool) -> some View {
    HStack {
        Text(text)
        Spacer()
        if isButton {
            Image(.chevronRight)
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
    .font(Fonts.pretendardBold(size: textSize))
    .foregroundColor(.white)
    .frame(height: 60)
}
