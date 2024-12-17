//
//  RUAlert.swift
//  RunUs
//
//  Created by seungyooooong on 9/5/24.
//

import SwiftUI

struct RUAlert: View {
    var imageUrl: String?
    var title: String
    var subTitle: String
    var mainButtonText: String
    var subButtonText: String
    var mainButtonColor: Color
    var mainButtonAction: () -> Void
    var subButtonAction: () -> Void
    var isSingleButtonAlert: Bool
    
    var body: some View {
        let hasSubTitle = subTitle.count > 0
        Group {
            VStack(spacing: 0) {
                if let imageUrl = imageUrl {
                    Spacer().frame(height: 16)
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 112, height: 112)
                }
                Spacer().frame(height: hasSubTitle ? 8 : 18)
                Text(title)
                    .lineSpacing(8)
                    .multilineTextAlignment(.center)
                    .font(Fonts.pretendardSemiBold(size: 16))
                    .frame(minHeight: hasSubTitle ? 0 : 40)
                Spacer().frame(height: hasSubTitle ? 12 : 0)
                Text(subTitle)
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .font(Fonts.pretendardRegular(size: 12))
                Spacer().frame(height: 20)
                HStack(spacing: 11) {
                    if !isSingleButtonAlert {
                        Button {
                            subButtonAction()
                        } label: {
                            Text(subButtonText)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(width: 121, height: 40)
                        .background(.mainDark)
                        .cornerRadius(6)
                    }
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
            .frame(width: 284)
            .background(.mainDeepDark)
            .cornerRadius(16)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.6))
        .ignoresSafeArea()
    }
}

#Preview {
    RUAlert(title: "정말 탈퇴 하시겠습니까?", subTitle: "탈퇴할 경우 모든 데이터가 삭제되고\n복구가 불가능합니다.", mainButtonText: "탈퇴하기", subButtonText: "취소", mainButtonColor: .red, mainButtonAction: {}, subButtonAction: {}, isSingleButtonAlert: false)
}
