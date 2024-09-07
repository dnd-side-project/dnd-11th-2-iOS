//
//  SelectRunningEmotionView.swift
//  RunUs
//
//  Created by Ryeong on 8/28/24.
//

import SwiftUI
import ComposableArchitecture

struct SelectRunningEmotionView: View {
    let store: StoreOf<RunningFeature>
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9).ignoresSafeArea()
            VStack(spacing: 34) {
                Text("오늘 달리기는 어떠셨나요?")
                HStack {
                    ForEach(RunningMood.allCases, id: \.self) { emotion in
                        if emotion == .none {
                            EmptyView()
                        } else {
                            NavigationLink {
                                RunningResultView(initialState: 
                                        .init(runningResult: store.state.getRunningResult(emotion: emotion)))
                                    .navigationBarBackButtonHidden()
                            } label: {
                                VStack(spacing: 14) {
                                    Image(emotion.icon)
                                    Text(emotion.text)
                                        .font(Fonts.pretendardRegular(size: 10))
                                }
                            }
                        }
                    }
                }.padding(.horizontal, 46)
            }.foregroundStyle(.white)
        }
    }
}
