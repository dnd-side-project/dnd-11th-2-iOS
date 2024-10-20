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
    
    @State var isReady: Bool = false
    @State var isShowStateBody: Bool = true
    
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
                runningView
                if store.runningState == .stop {
                    SelectRunningEmotionView(store: store)
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

extension RunningView {
    private var runningView: some View {
        VStack(spacing: 0) {
            Map(position: $store.userLocation) {
                UserAnnotation {
                    Image(.userLocationMark)
                }
            }
            .padding(.bottom, -80)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            Button {
                isShowStateBody = true
            } label: {
                Image(.buttonRunningStateUp).padding()
            }
            .opacity(isShowStateBody ? 0 : 1)
            runningStateView
            .background(Color.background)
            .cornerRadius(12, corners: [.topLeft, .topRight])
            .shadow(color: .black.opacity(0.5), radius: 30, x: 0, y: -10)
            .zIndex(1)
        }
        .animation(.easeInOut, value: isShowStateBody)
    }
    
    private var runningStateView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 24)
            runningStateTitleView
            if isShowStateBody {
                runningStateBodyView
                Spacer().frame(height: 15)
            }
            Spacer().frame(height: 34)
        }
    }
    
    private var runningStateTitleView: some View {
        HStack(spacing: 8) {
            Image(.runningStateShoes)
                .resizable()
                .frame(width: 25, height: 25)
            Text("현재 러닝 현황")
                .font(Fonts.pretendardSemiBold(size: 20))
                .foregroundStyle(.white)
            Spacer()
        }.padding(.horizontal, Paddings.outsideHorizontalPadding)
    }
    
    private var runningStateBodyView: some View {
        VStack(spacing: 32) {
            VStack(spacing: 6) {
                Text(store.distance.kmDistanceFormat)
                    .font(Fonts.pretendardBlack(size: 84))
                    .foregroundStyle(.white)
                smallText("킬로미터")
            }
            
            HStack {
                VStack(spacing: 6) {
                    mediumText("\(store.pace)")
                    smallText("실시간 페이스")
                }
                .frame(maxWidth: .infinity)
                VStack(spacing: 6) {
                    mediumText("\(store.time.toTimeString().formatToTime)")
                    smallText("시간")
                }
                .frame(maxWidth: .infinity)
                VStack(spacing: 6) {
                    mediumText("\(Int(store.kcal))")
                    smallText("칼로리")
                }
                .frame(maxWidth: .infinity)
            }
            
            ZStack {
                runningButtons
                HStack {
                    Spacer()
                    Button {
                        isShowStateBody = false
                    } label: {
                        runningButton(.buttonMap)
                    }
                }
            }
            .padding(.horizontal, Paddings.outsideHorizontalPadding)
        }
    }
    
    private var runningButtons: some View {
        HStack(spacing: 22) {
            if store.runningState == .running {
                Button(action: {
                    store.send(.setRunningState(.pause))
                }, label: {
                    runningButton(.buttonPause)
                })
            } else {
                Button(action: {
                    store.send(.runningEnd)
                    store.send(.setRunningState(.stop))
                }, label: {
                    runningButton(.buttonStop)
                })
                
                Button(action: {
                    store.send(.setRunningState(.running))
                }, label: {
                    runningButton(.buttonResume)
                })
            }
        }
    }
    
    private func runningButton(_ image: ImageResource) -> some View {
        let isMap = image == .buttonMap
        let size: CGFloat = isMap ? 24 : 20
        let padding: CGFloat = isMap ? 8 : 20
        return Image(image)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .padding(padding)
            .background {
                Circle()
                    .fill(.mainDeepDark)
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
