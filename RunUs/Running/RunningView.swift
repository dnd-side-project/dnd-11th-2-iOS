//
//  RunningView.swift
//  RunUs
//
//  Created by Ryeong on 8/13/24.
//

import SwiftUI
import MapKit

struct RunningView: View {
    var body: some View {
        ZStack {
            Map()
            VStack {
                Spacer()
                runningStateView
            }
        }
    }
}

extension RunningView {
    private var runningStateView: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack(spacing: 32) {
                HStack(spacing: 8) {
                    Image(.runningStateShoes)
                        .resizable()
                        .frame(width: 19, height: 19)
                    Text("현재 러닝 현황")
                        .font(Fonts.pretendardSemiBold(size: 20))
                        .foregroundStyle(.white)
                    Spacer()
                }.padding(.horizontal, Paddings.outsideHorizontalPadding)
                
                VStack{
                    Text("2.07")
                        .font(Fonts.pretendardBlack(size: 84))
                        .foregroundStyle(.white)
                    smallText("킬로미터")
                }
                
                HStack {
                    VStack {
                        mediumText("0’00”")
                        smallText("평균페이스")
                    }
                    Spacer()
                    VStack {
                        mediumText("30:15")
                        smallText("시간")
                    }
                    Spacer()
                    VStack {
                        mediumText("1.5km")
                        smallText("킬로미터")
                    }
                }
                .padding(.horizontal, 21.5)
                
                Circle()
                    .frame(width: 60)
                    .foregroundStyle(.mainDeepDark)
                    .overlay {
                        Image(.buttonPause)
                    }
            }
        }.frame(height: 406)
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
    RunningView()
}
