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
                    RUUserLocationMark()
                }
                HeatMapPolylineContent(segments: store.routeSegments)
            }
            .padding(.bottom, -80)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            Button {
                isShowStateBody = true
            } label: {
                Image(.Running.chevronUp).padding()
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
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(.Running.shoes)
                    .resizable()
                    .frame(width: 25, height: 25)
                Text(store.achievementMode == .normal ? "현재 러닝 현황" : "\(store.goalString) 달성률")
                    .font(store.achievementMode == .normal ? Fonts.pretendardSemiBold(size: 20) : Fonts.pretendardMedium(size: 15))
                    .foregroundStyle(.white)
                Spacer()
            }
            if store.achievementMode != .normal { RUProgress(percent: store.goalPercent, hasPin: false) }
        }
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
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
                        runningButton(.Running.map)
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
                    runningButton(.Running.pause)
                })
            } else {
                Button(action: {
                    store.send(.runningEnd)
                    store.send(.setRunningState(.stop))
                }, label: {
                    runningButton(.Running.stop)
                })
                
                Button(action: {
                    store.send(.setRunningState(.running))
                }, label: {
                    runningButton(.Running.resume)
                })
            }
        }
    }
    
    private func runningButton(_ image: ImageResource) -> some View {
        let isMap = image == .Running.map
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
