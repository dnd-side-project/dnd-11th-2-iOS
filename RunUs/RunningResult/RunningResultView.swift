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
                if let achievementResult = store.achievementResult {
                    Spacer().frame(height: 26)
                    RUTitle(text: "\(store.achievementMode == .challenge ? "오늘의 러닝 챌린지" : "오늘의 러닝 목표")", textSize: 20)
                    achievementView(achievementResult)
                }
                Spacer().frame(height: 28)
                RUTitle(text: "오늘의 러닝 페이스", textSize: 20)
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
    
    private func achievementView(_ achievementResult: AchievementResult) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(spacing: 10) {
                AsyncImage(url: URL(string: achievementResult.iconUrl)) { image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 48, height: 48)
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(achievementResult.title)")
                        .font(Fonts.pretendardSemiBold(size: 16))
                    Text("\(achievementResult.subTitle)")
                        .font(Fonts.pretendardRegular(size: 12))
                }
            }
            RUProgress(percent: achievementResult.percentage)
        }
        .grayscale(achievementResult.isSuccess ? 0 : 1)
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
        .padding(.vertical, 20)
        .background(.mainDeepDark)
        .cornerRadius(12)
    }

    private var resultView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                Text(store.distance.kmDistanceFormat)
                    .font(Fonts.pretendardBlack(size: 84))
                    .padding(.top, -10) // MARK: 텍스트 윗 공간 여백을 줄여 UI를 맞추기 위한 임시 처리
                smallText("킬로미터")
            }
            Spacer().frame(height: 32)
            HStack {
                VStack(spacing: 4) {
                    mediumText("\(store.averagePace)")
                    smallText("평균 페이스")
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
                Spacer()
            }
        }
    }
    
    private func smallText(_ string: String) -> some View {
        Text(string)
            .font(Fonts.pretendardRegular(size: 14))
            .foregroundStyle(.gray200)
    }
    
    private func mediumText(_ string: String) -> some View {
        Text(string)
            .font(Fonts.pretendardBold(size: 26))
            .foregroundStyle(.white)
    }
}
