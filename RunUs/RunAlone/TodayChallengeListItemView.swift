//
//  TodayChallengeListItemView.swift
//  RunUs
//
//  Created by Ryeong on 8/7/24.
//

import SwiftUI

struct TodayChallengeListItemView: View {
    let challenge: TodayChallenge
    var hasShadowPadding: Bool = true
    var backgroundColor: Color = .mainDark
    
    var body: some View {
        VStack {
            if hasShadowPadding { shadowPadding }
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: challenge.icon)) { image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 56, height: 56)
                .padding(.leading, Paddings.outsideHorizontalPadding)
                VStack(alignment: .leading, spacing: 8) {
                    Text(challenge.title)
                        .font(Fonts.pretendardSemiBold(size: 16))
                    Text("소요시간 • \(challenge.expectedTime)")
                        .font(Fonts.pretendardMedium(size: 10))
                }
                .foregroundStyle(.white)
                Spacer()
            }
            .frame(width: 280, height: 91)
            .background(challenge.isSelected ? .background : backgroundColor)
            .cornerRadius(12, corners: .allCorners)
            .if(challenge.isSelected, transform: { view in
                view.shadow(color: .black.opacity(0.7), radius: 10, x: 1, y: 1)
            })
            if hasShadowPadding { shadowPadding }
        }
    }
}

extension TodayChallengeListItemView {
    private var shadowPadding: some View {
        Spacer()
            .frame(height: 20)
    }
}

#Preview {
    TodayChallengeListItemView(challenge: .init(id: 0, title: "어제보다 더뛰기", expectedTime: "10분", icon: "SampleImage"))
}
