//
//  SelectRunningEmotionView.swift
//  RunUs
//
//  Created by Ryeong on 8/28/24.
//

import SwiftUI
import ComposableArchitecture

struct SelectRunningEmotionView: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @State var store: StoreOf<RunningFeature>
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9).ignoresSafeArea()
            VStack(spacing: 34) {
                Text("오늘 달리기는 어떠셨나요?")
                HStack(spacing: 12) {
                    Spacer()
                    ForEach(Emotions.allCases, id: \.self) { emotion in
                        if emotion == .none {
                            EmptyView()
                        } else {
                            Button {
                                let navigationObject = NavigationObject(
                                    viewType: .runningResult,
                                    data: store.state.getRunningResult(emotion: emotion)
                                )
                                viewEnvironment.navigationPath.append(navigationObject)
                                store.send(.resetRunningState)
                            } label: {
                                VStack(spacing: 14) {
                                    Image(emotion.icon)
                                        .resizable()
                                        .scaledToFit()
                                    Text(emotion.text)
                                        .font(Fonts.pretendardRegular(size: 10))
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            .foregroundStyle(.white)
        }
    }
}
