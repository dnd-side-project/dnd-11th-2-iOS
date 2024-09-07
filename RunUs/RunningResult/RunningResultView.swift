//
//  RunningResultView.swift
//  RunUs
//
//  Created by Ryeong on 8/23/24.
//

import SwiftUI
import ComposableArchitecture

struct RunningResultView: View {
    let store: StoreOf<RunningResultFeature>
    
    init(initialState: RunningResultFeature.State) {
        self.store = .init(
            initialState: initialState,
            reducer: { RunningResultFeature() })
    }
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                RUNavigationBar(buttonType: .home{ }, title: "러닝결과")
                    .padding(.bottom, 26)
                Text("\(store.date)")
                    .font(Fonts.pretendardMedium(size: 14))
                    .padding(.bottom, 20)
                MoodView
                    .padding(.bottom, 28)
                if let challengResult = store.challengeResult {
                    Text("오늘의 러닝 챌린지")
                        .font(Fonts.pretendardBold(size: 20))
                        .padding(.bottom, 18)
                    challengeView(challengResult)
                }
                if let goalResult = store.goalResult {
                    Text("오늘의 러닝 목표")
                        .font(Fonts.pretendardBold(size: 20))
                        .padding(.bottom, 18)
                    goalView(goalResult)
                }
                Text("오늘의 러닝 페이스")
                    .font(Fonts.pretendardBold(size: 20))
                    .padding(.top, 36)
                resultView
                Spacer()
            }
            .foregroundStyle(.white)
            .padding(.horizontal, Paddings.outsideHorizontalPadding)
            .onAppear{
                store.send(.onAppear)
            }
        }
    }
}

extension RunningResultView {
    private var MoodView: some View {
        HStack(spacing: 16) {
            Image(store.state.mood.icon)
            Text("\(store.state.mood.text)")
                .font(Fonts.pretendardBold(size: 16))
                .foregroundStyle(.white)
            Spacer()
        }
    }
    private func challengeView(_ challengeResult: ChallengeResult) -> some View {
        HStack {
            Image(challengeResult.iconUrl)
                .padding(.leading, 14)
            VStack(alignment: .leading) {
                Text("\(challengeResult.title)")
                    .font(Fonts.pretendardSemiBold(size: 16))
                Text("\(challengeResult.subTitle)")
                    .font(Fonts.pretendardRegular(size: 12))
            }
            .padding(.leading, 10)
            Spacer()
            Text(challengeResult.isSuccess ?
                 "도전 성공!" : "도전 실패!")
                .font(Fonts.pretendardSemiBold(size: 10))
                .frame(width: 83, height: 26)
                .foregroundStyle(challengeResult.isSuccess ?
                    .mainDeepDark : .white)
                .background(challengeResult.isSuccess ?
                    .mainGreen : .red)
                .cornerRadius(6, corners: .allCorners)
                .padding(.trailing, 11)
        }
        .frame(height: 84)
        .background(.mainDeepDark)
        .cornerRadius(12, corners: .allCorners)
    }
    
    private func goalView(_ goalResult: GoalResult) -> some View {
        HStack {
            Image(goalResult.isSuccess ? .goalSuccess : .goalFail)
                .padding(.leading, 14)
            VStack(alignment: .leading) {
                Text("\(goalResult.title)")
                    .font(Fonts.pretendardSemiBold(size: 16))
                Text("\(goalResult.subTitle)")
                    .font(Fonts.pretendardRegular(size: 12))
            }
            .padding(.leading, 10)
            Spacer()
        }
        .frame(height: 84)
        .background(.mainDeepDark)
        .cornerRadius(12, corners: .allCorners)
    }
    
    private var resultView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(store.distance == 0.0 ? "0.0" : String(format: "%.2f", 0.0))
                .font(Fonts.pretendardBlack(size: 84))
            SmallText("킬로미터")
            
            HStack {
                VStack {
                    MediumText("\(store.averagePace)")
                    SmallText("평균페이스")
                }
                Spacer()
                VStack {
                    MediumText("\(store.runningTime)")
                    SmallText("시간")
                }
                Spacer()
                VStack {
                    MediumText("\(store.kcal)")
                    SmallText("칼로리")
                }
            }
            .padding(.top, 32)
            .padding(.bottom, 52)
        }
    }
}
