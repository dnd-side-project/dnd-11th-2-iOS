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
    let store: StoreOf<RunningFeature> = .init(
        initialState: RunningFeature.State(),
        reducer: { RunningFeature() })
    
    @State var isStateHidden: Bool = false
    @State var userLocation: MapCameraPosition =
        .userLocation(followsHeading: true, fallback: .automatic)
    @State var isReady: Bool = false
    
    var body: some View {
        if !isReady {
            ZStack {
                Color.background.ignoresSafeArea()
                CountDownView(isFinished: $isReady)
            }
        } else {
            ZStack {
                Map(position: $userLocation) {
                    UserAnnotation {
                        Image(.userLocationMark)
                    }
                }
                .padding(.bottom, isStateHidden ? 0 : 350)
                
                VStack() {
                    Spacer()
                    if isStateHidden {
                        Button(action: {
                            isStateHidden = false
                        }, label: {
                            Image(.buttonRunningStateUp)
                                .padding([.top,.horizontal])
                        })
                    }
                    VStack(spacing:0) {
                        if isStateHidden {
                            runningStateTitleView
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
            
            VStack{
                Text(store.distance == 0.00 ? "0.0" : String(format: "%.2f", store.distance))
                    .font(Fonts.pretendardBlack(size: 84))
                    .foregroundStyle(.white)
                smallText("킬로미터")
            }
            
            HStack {
                VStack {
                    mediumText("\(store.pace)")
                    smallText("평균페이스")
                }
                Spacer()
                VStack {
                    mediumText("\(store.time.toTimeString())")
                    smallText("시간")
                }
                Spacer()
                VStack {
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
            if store.isRunning {
                Button(action: {
                    store.send(.isRunningChanged(false))
                }, label: {
                    CircleButtonView(.buttonPause)
                })
            } else {
                Button(action: {
                    //TODO: 러닝 결과 화면으로 이동
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

#Preview {
    RunningView()
}
