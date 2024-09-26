//
//  RUChallengeList.swift
//  RunUs
//
//  Created by seungyooooong on 9/25/24.
//

import Foundation
import SwiftUI

struct RUChallengeList: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    var challenges: [TodayChallenge]
    var listHorizontalPadding: CGFloat = 0
    var scrollHorizontalPadding: CGFloat = 0
    var itemHasShadow: Bool = true
    var itemBackgroundColor: Color = .mainDark
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(challenges.indices, id: \.self) { index in
                    Button(action: {
                        viewEnvironment.selectedTabItem = .running
                        viewEnvironment.selectedRunningMode = .challenge
                        viewEnvironment.selectedChallengeIndex = index
                    }, label: {
                        RUChallengeItem(challenge: challenges[index], hasShadow: itemHasShadow, backgroundColor: itemBackgroundColor)
                    })
                }
            }
            .padding(.horizontal, listHorizontalPadding)
        }
        .padding(.horizontal, scrollHorizontalPadding)
    }
}

struct RUChallengeItem: View {
    let challenge: TodayChallenge
    var hasShadow: Bool = true
    var backgroundColor: Color = .mainDark
    
    var body: some View {
        VStack {
            if hasShadow { shadowPadding }
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
            if hasShadow { shadowPadding }
        }
    }
}

extension RUChallengeItem {
    private var shadowPadding: some View {
        Spacer().frame(height: 20)
    }
}
