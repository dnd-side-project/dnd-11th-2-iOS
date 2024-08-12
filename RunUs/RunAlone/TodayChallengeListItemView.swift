//
//  TodayChallengeListItemView.swift
//  RunUs
//
//  Created by Ryeong on 8/7/24.
//

import SwiftUI

struct TodayChallengeListItemView: View {
    let challenge: TodayChallenge
    
    var body: some View {
        HStack(spacing: 16) {
            Image(challenge.imageUrl)
                .resizable()
                .frame(width: 56, height: 56)
                .padding(.leading, Paddings.outsideHorizontalPadding)
            VStack(alignment: .leading, spacing: 8) {
                Text(challenge.title)
                    .font(Fonts.pretendardSemiBold(size: 16))
                Text("소요시간 • \(challenge.estimatedMinute)분")
                    .font(Fonts.pretendardMedium(size: 10))
            }
            .foregroundStyle(.white)
            Spacer()
        }
        .frame(width: 280, height: 91)
        .background(challenge.isSelected ? .background : .mainDark)
        .cornerRadius(12, corners: .allCorners)
        .if(challenge.isSelected, transform: { view in
            view.shadow(color: .black.opacity(0.7), radius: 20, x: 1, y: 1)
        })
        
    }
}

#Preview {
    TodayChallengeListItemView(challenge: .init(id: 0, imageUrl: "SampleImage", title: "어제보다 더뛰기", estimatedMinute: 10, isSelected: true))
}
