//
//  RUButton.swift
//  RunUs
//
//  Created by seungyooooong on 8/15/24.
//

import SwiftUI

struct RUButton: View {
    let action: () -> Void
    let text: String
    var disableCondition: Bool = false
    
    var body: some View {
        Button {
            if disableCondition {
                // MARK: no action
            } else {
                action()
            }
        } label: {
            Text(text)
                .frame(height: 24)
                .font(Fonts.pretendardBold(size: 16))
                .foregroundColor(disableCondition ? .white : .black)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(disableCondition ? .mainDeepDark : .mainGreen)
        }
        Spacer().frame(height: 24).frame(maxWidth: .infinity)
    }
}

#Preview {
    RUButton(action: {}, text: "목표 설정 완료", disableCondition: true)
}
