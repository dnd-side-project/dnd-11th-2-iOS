//
//  RunningView.swift
//  RunUs
//
//  Created by Ryeong on 8/13/24.
//

import SwiftUI
import MapKit

struct RunningView: View {
    @State var isRunning: Bool = false
    @State var isStateHidden: Bool = true
    
    var body: some View {
        ZStack {
            Map()
            VStack() {
                Spacer()
                if isStateHidden {
                    Button(action: {
                        isStateHidden = false
                    }, label: {
                        Image(.buttonRunningStateUp)
                    })
                }
                VStack(spacing:0) {
                    if isStateHidden {
                            runningStateTitleView
                    } else {
                        runningStateView
                    }
                }
                .frame(height: isStateHidden ? 70 : 406)
                .background(Color.background)
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .shadow(color: .black.opacity(0.5), radius: 30, x: 1, y: 1)
            }
            .ignoresSafeArea()
        }
    }
}

extension RunningView {
    private var runningStateView: some View {
            VStack(spacing: 32) {
                runningStateTitleView
                
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
                
                ZStack {
                    runningButtons
                    HStack {
                        Spacer()
                        Button {
                            isStateHidden = true
                        } label: {
                            CircleButtonView(size: 40,
                                             .buttonMap)
                        }
                    }
                }
                .padding(Paddings.outsideHorizontalPadding)
            }
    }
    
    private var runningStateTitleView: some View {
        HStack(spacing: 8) {
            Image(.runningStateShoes)
                .resizable()
                .frame(width: 19, height: 19)
            Text("현재 러닝 현황")
                .font(Fonts.pretendardSemiBold(size: 20))
                .foregroundStyle(.white)
            Spacer()
        }.padding(.horizontal, Paddings.outsideHorizontalPadding)
    }
    
    private var runningButtons: some View {
        HStack(spacing: 22) {
            if isRunning {
                CircleButtonView(.buttonPause)
            } else {
                CircleButtonView(.buttonStop)
                CircleButtonView(.buttonResume)
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

#Preview {
    RunningView()
}
