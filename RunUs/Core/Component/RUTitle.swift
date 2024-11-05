//
//  RUTitle.swift
//  RunUs
//
//  Created by seungyooooong on 10/7/24.
//

import SwiftUI

struct RUTitle: View {
    let action: () -> Void
    let text: String
    let textSize: CGFloat
    let isButton: Bool
    
    init(action: (() -> Void)? = nil, text: String, textSize: CGFloat = 16) {
        self.text = text
        self.textSize = textSize
        if let action = action {
            self.isButton = true
            self.action = action
        } else {
            self.isButton = false
            self.action = { }
        }
    }
    
    var body: some View {
        if isButton {
            Button {
                action()
            } label: {
                ruTitle(text: text, textSize: textSize, isButton: isButton)
            }
        } else {
            ruTitle(text: text, textSize: textSize, isButton: isButton)
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

}
