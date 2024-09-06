//
//  RUAlert.swift
//  RunUs
//
//  Created by seungyooooong on 9/5/24.
//

import SwiftUI

struct RUAlert: View {
    var title: String
    var subTitle: String
    var mainButtonText: String
    var subButtonText: String
    var mainButtonColor: Color
    var mainButtonAction: () -> Void
    var subButtonAction: () -> Void
    
    var body: some View {
        Group {
            VStack(spacing: 0) {
                Text(title)
                    .font(Fonts.pretendardSemiBold(size: 16))
                    .padding(.top, subTitle.count > 0 ? 8 : 18)
                    .padding(.bottom, subTitle.count > 0 ? 12 : 10)
                Text(subTitle)
                    .multilineTextAlignment(.center)
                    .font(Fonts.pretendardRegular(size: 12))
                    .padding(.bottom, 20)
                HStack(spacing: 11) {
                    Button {
                        subButtonAction()
                    } label: {
                        Text(subButtonText)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(width: 121, height: 40)
                    .background(.mainDark)
                    .cornerRadius(6)
                    Button {
                        mainButtonAction()
                    } label: {
                        Text(mainButtonText)
                            .foregroundStyle(mainButtonColor == .mainGreen ? .black : .white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(width: 121, height: 40)
                    .background(mainButtonColor)
                    .cornerRadius(6)
                }
                .font(Fonts.pretendardBold(size: 14))
            }
            .padding(Paddings.outsideHorizontalPadding)
            .background(.mainDeepDark)
            .cornerRadius(16)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.7))
        .ignoresSafeArea()
    }
}

#Preview {
    RUAlert(title: "정말 탈퇴 하시겠습니까?", subTitle: "탈퇴할 경우 모든 데이터가 삭제되고\n복구가 불가능합니다.", mainButtonText: "탈퇴하기", subButtonText: "취소", mainButtonColor: .red, mainButtonAction: {}, subButtonAction: {})
}
