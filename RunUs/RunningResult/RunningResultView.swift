//
//  RunningResultView.swift
//  RunUs
//
//  Created by Ryeong on 8/23/24.
//

import SwiftUI
import ComposableArchitecture

struct RunningResultView: View {
    let store: StoreOf<RunningResultFeature> = .init(
        initialState: RunningResultFeature.State(),
        reducer: { RunningResultFeature() })
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RUNavigationBar(buttonType: .home{ }, title: "러닝결과")
                .padding(.bottom, 26)
            Text("\(store.date)")
                .font(Fonts.pretendardMedium(size: 14))
                .padding(.bottom, 20)
            MoodView
                .padding(.bottom, 28)
            Text("오늘의 러닝 챌린지")
                .font(Fonts.pretendardBold(size: 20))
                .padding(.bottom, 18)
            challengeView
            Spacer()
            Text("오늘의 러닝 페이스")
                .font(Fonts.pretendardBold(size: 20))
            resultView
        }
        .foregroundStyle(.white)
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
        .background(Color.background)
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
    
    private var challengeView: some View {
        HStack {
            Image(store.challengeResult.icon)
                .padding(.leading, 14)
            VStack(alignment: .leading) {
                Text("\(store.challengeResult.title)")
                    .font(Fonts.pretendardSemiBold(size: 16))
                Text("\(store.challengeResult.subtitle)")
                    .font(Fonts.pretendardRegular(size: 12))
            }
            .padding(.leading, 10)
            Spacer()
            Text(store.challengeResult.isSuccess ?
                 "도전 성공!" : "도전 실패!")
                .font(Fonts.pretendardSemiBold(size: 10))
                .frame(width: 83, height: 26)
                .foregroundStyle(store.challengeResult.isSuccess ?
                    .mainDeepDark : .white)
                .background(store.challengeResult.isSuccess ?
                    .mainGreen : .red)
                .cornerRadius(6, corners: .allCorners)
                .padding(.trailing, 11)
        }
        .frame(height: 84)
        .background(.mainDeepDark)
        .cornerRadius(12, corners: .allCorners)
    }
    
    //FIXME: 러닝 현황에 있는 mediumText, smallText 재사용
    private var resultView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(store.distance == 0.0 ? "0.0" : String(format: "%.2f", 0.0))
                .font(Fonts.pretendardBlack(size: 84))
            smallText("킬로미터")
            
            HStack {
                VStack {
                    mediumText("\(store.averagePace)")
                    smallText("평균페이스")
                }
                Spacer()
                VStack {
                    mediumText("\(store.runningTime)")
                    smallText("시간")
                }
                Spacer()
                VStack {
                    mediumText("\(store.kcal)")
                    smallText("칼로리")
                }
            }
            .padding(.top, 32)
            .padding(.bottom, 52)
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

#Preview {
    RunningResultView()
}
