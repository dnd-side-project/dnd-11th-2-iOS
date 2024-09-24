//
//  RunningView.swift
//  RunUs
//
//  Created by Ryeong on 8/13/24.
//

import SwiftUI
import MapKit
import ComposableArchitecture

struct RunningView: View {
    @State var store: StoreOf<RunningFeature>
    
    @Namespace private var namespace
    
    @State var isStateHidden: Bool = false
    @State var isReady: Bool = false
    
    init(_ runningStartInfo: RunningStartInfo) {
        self.store = Store(initialState: RunningFeature.State(runningStartInfo: runningStartInfo), reducer: { RunningFeature() })
    }
    
    var body: some View {
        if !isReady {
            ZStack {
                Color.background.ignoresSafeArea()
                CountDownView(isReady: $isReady)
            }
        } else {
            ZStack {
                Map(position: $store.userLocation) {
                    UserAnnotation {
                        Image(.userLocationMark)
                    }
                }
                .padding(.bottom, isStateHidden ? 0 : 350)
                
                VStack() {
                    Spacer()
                    if isStateHidden {
                        Button(action: {
                            withAnimation {
                                isStateHidden = false
                            }
                        }, label: {
                            Image(.buttonRunningStateUp)
                                .padding([.top,.horizontal])
                        })
                    }
                    VStack(spacing:0) {
                        if isStateHidden {
                            runningStateTitleView
                                .matchedGeometryEffect(id: "runnningStateTitleView", in: namespace)
                        } else {
                            runningStateView
                        }
                    }
                    .frame(height: isStateHidden ? 85 : 406)
                    .background(Color.background)
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                    .shadow(color: .black.opacity(0.5), radius: 30, x: 1, y: 1)
                }
                .ignoresSafeArea()
                if store.isRunningEnd {
                    SelectRunningEmotionView(store: store)
                }
            }
            .onAppear{
                store.send(.onAppear)
            }
        }
    }
}

extension RunningView {
    private var runningStateView: some View {
        VStack(spacing: 32) {
            runningStateTitleView
                .matchedGeometryEffect(id: "runnningStateTitleView", in: namespace)
            
            VStack(spacing: 6) {
                Text(String(format: "%.2f", store.distance))
                    .font(Fonts.pretendardBlack(size: 84))
                    .foregroundStyle(.white)
                smallText("킬로미터")
            }
            
            HStack {
                VStack(spacing: 6) {
                    mediumText("\(store.pace)")
                    smallText("평균페이스")
                }
                Spacer()
                VStack(spacing: 6) {
                    mediumText("\(store.time.toTimeString().formatToTime)")
                    smallText("시간")
                }
                Spacer()
                VStack(spacing: 6) {
                    mediumText("\(store.kcal)")
                    smallText("칼로리")
                }
            }
            .padding(.horizontal, 21.5)
            
            ZStack {
                runningButtons
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            isStateHidden = true
                        }
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
            if store.isRunning {
                Button(action: {
                    store.send(.isRunningChanged(false))
                }, label: {
                    CircleButtonView(.buttonPause)
                })
            } else {
                Button(action: {
                    store.send(.runningEnd)
                }, label: {
                    CircleButtonView(.buttonStop)
                })
                
                Button(action: {
                    store.send(.isRunningChanged(true))
                }, label: {
                    CircleButtonView(.buttonResume)
                })
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
