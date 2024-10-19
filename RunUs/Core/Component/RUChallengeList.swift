//
//  RUChallengeList.swift
//  RunUs
//
//  Created by seungyooooong on 9/25/24.
//

import Foundation
import SwiftUI

struct RUChallengeList: View {
    @Binding var selectedChallengeIndex: Int
    @Binding var challenges: [TodayChallenge]
    let selectAction: (Int) -> Void
    var listHorizontalPadding: CGFloat = 0
    var scrollHorizontalPadding: CGFloat = 0
    var itemHasShadow: Bool = true
    var itemBackgroundColor: Color = .mainDark
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(challenges.indices, id: \.self) { index in
                    Button {
                        selectAction(index)
                    } label: {
                        RUChallengeItem(
                            isSelected: .constant(index == selectedChallengeIndex),
                            challenge: challenges[index],
                            hasShadow: itemHasShadow,
                            backgroundColor: itemBackgroundColor
                        )
                    }
                }
            }
            .padding(.horizontal, listHorizontalPadding)
        }
        .padding(.horizontal, scrollHorizontalPadding)
    }
}

struct RUChallengeItem: View {
    @Binding var isSelected: Bool
    let challenge: TodayChallenge
    let hasShadow: Bool
    let backgroundColor: Color
    
    var body: some View {
        VStack {
            if hasShadow { shadowPadding }
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: challenge.icon)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 56, height: 56)
                .padding(.leading, Paddings.outsideHorizontalPadding)
                VStack(alignment: .leading, spacing: 8) {
                    Text(challenge.title)
                        .font(Fonts.pretendardSemiBold(size: 16))
                    Text("소요시간 • \(challenge.expectedTime)")
                        .font(Fonts.pretendardMedium(size: 14))
                }
                .foregroundStyle(.white)
                Spacer()
            }
            .frame(width: 280, height: 91)
            .background(isSelected && hasShadow ? .background : backgroundColor)
            .cornerRadius(12)
            .if(isSelected , transform: { view in
                view.shadow(color: .black.opacity(0.7), radius: 10, x: 1, y: 1)
            })
            if hasShadow { shadowPadding }
        }
    }
}

extension RUChallengeItem {
    private var shadowPadding: some View {
        Spacer().frame(height: 20)
    }
}
