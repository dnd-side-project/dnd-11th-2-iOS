//
//  RunningResultView.swift
//  RunUs
//
//  Created by Ryeong on 8/23/24.
//

import SwiftUI
import ComposableArchitecture

struct RunningResultView: View {
    @State var store: StoreOf<RunningResultFeature>
    let navigationButtonType: NavigationButtonType
    
    init(runningResult: RunningResult) {
        self.store = Store(initialState: RunningResultFeature.State(runningResult: runningResult), reducer: { RunningResultFeature() })
        self.navigationButtonType = .home
    }
    init(runningRecord: RunningRecord) {
        self.store = Store(initialState: RunningResultFeature.State(runningRecord: runningRecord), reducer: { RunningResultFeature() })
        self.navigationButtonType = .back
    }
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                RUNavigationBar(buttonType: navigationButtonType, title: "러닝결과")
                Spacer().frame(height: 26)
                Text("\(store.date)")
                    .font(Fonts.pretendardMedium(size: 14))
                Spacer().frame(height: 15)
                EmotionView
                if let challengResult = store.challengeResult {
                    Spacer().frame(height: 44)
                    Text("오늘의 러닝 챌린지")
                        .font(Fonts.pretendardBold(size: 20))
                    Spacer().frame(height: 18)
                    challengeView(challengResult)
                }
                if let goalResult = store.goalResult {
                    Spacer().frame(height: 44)
                    Text("오늘의 러닝 목표")
                        .font(Fonts.pretendardBold(size: 20))
                    Spacer().frame(height: 18)
                    goalView(goalResult)
                }
                Spacer().frame(height: 46)
                Text("오늘의 러닝 페이스")
                    .font(Fonts.pretendardBold(size: 20))
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
    private var EmotionView: some View {
        HStack(spacing: 16) {
            Image(store.state.emotion.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            Text("\(store.state.emotion.text)")
                .font(Fonts.pretendardBold(size: 16))
                .foregroundStyle(.white)
            Spacer()
        }
    }
    private func challengeView(_ challengeResult: ChallengeResult) -> some View {
        HStack {
            AsyncImage(url: URL(string: challengeResult.iconUrl)) { image in
                image
                    .resizable()
                    .grayscale(challengeResult.isSuccess ? 0 : 1)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 48, height: 48)
            .padding(.leading, 14)
            VStack(alignment: .leading) {
                Text("\(challengeResult.title)")
                    .font(Fonts.pretendardSemiBold(size: 16))
                Text("\(challengeResult.subTitle)")
                    .font(Fonts.pretendardRegular(size: 12))
            }
            .padding(.leading, 10)
            Spacer()
            Text(challengeResult.isSuccess ? "도전 성공!" : "도전 실패!")
                .font(Fonts.pretendardSemiBold(size: 10))
                .frame(width: 83, height: 26)
                .foregroundStyle(challengeResult.isSuccess ? .mainDeepDark : .white)
                .background(challengeResult.isSuccess ? .mainGreen : .gray300)
                .cornerRadius(6, corners: .allCorners)
                .padding(.trailing, 11)
        }
        .frame(height: 84)
        .background(.mainDeepDark)
        .cornerRadius(12, corners: .allCorners)
    }
    
    private func goalView(_ goalResult: GoalResult) -> some View {
        HStack {
            AsyncImage(url: URL(string: goalResult.iconUrl)) { image in
                image
                    .resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 56, height: 56)
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
            Text(String(format: "%.2f", store.distance))
                .font(Fonts.pretendardBlack(size: 84))
            smallText("킬로미터")
            Spacer().frame(height: 32)
            HStack {
                VStack(spacing: 4) {
                    mediumText("\(store.averagePace)")
                    smallText("평균페이스")
                }
                Spacer()
                VStack(spacing: 4) {
                    mediumText("\(store.runningTime.formatToTime)")
                    smallText("시간")
                }
                Spacer()
                VStack(spacing: 4) {
                    mediumText("\(store.kcal)")
                    smallText("칼로리")
                }
            }
        }
    }
    
    private func smallText(_ string: String) -> some View {
        Text(string)
            .font(Fonts.pretendardRegular(size: 12))
            .foregroundStyle(.gray200)
    }
    
    private func mediumText(_ string: String) -> some View {
        Text(string)
            .font(Fonts.pretendardBold(size: 26))
            .foregroundStyle(.white)
    }
}
