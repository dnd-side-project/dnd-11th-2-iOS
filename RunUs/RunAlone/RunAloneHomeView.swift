//
//  RunAloneHomeView.swift
//  RunUs
//
//  Created by Ryeong on 8/5/24.
//

import SwiftUI
import ComposableArchitecture
import MapKit

struct RunAloneHomeView: View {
    @Environment(\.dismiss) var dismiss
    @State var store: StoreOf<RunAloneHomeFeature> = .init( 
        initialState: RunAloneHomeFeature.State(),
        reducer: { RunAloneHomeFeature() })
    
    var body: some View {
        NavigationView {
            ZStack {
                Map()
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        RUNavigationBar(buttonType: .back,
                                        title: "혼자뛰기")
                        runninModeView
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                    .padding(.horizontal, Paddings.outsideHorizontalPadding)
                    .background(Color.background)
                    
                    Spacer()
                        .frame(height: 64)
                    
                    VStack {
                        // 현재 모드에 따라 전환되는 화면
                        switch store.mode {
                        case .normal:
                            EmptyView()
                        case .challenge:
                            todayChallengeListView(store.todayChallengeList)
                                .transition(.scale)
                        case .goal:
                            goalView
                                .transition(.scale)
                        }
                    }
                    .animation(.easeInOut, value: store.mode)
                    
                    Spacer()
                    startButton
                    Spacer()
                        .frame(height: 48)
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
            .alert(Bundle.main.locationString,
                   isPresented: $store.showLocationPermissionAlert) {
                Button("취소") { }
                Button("설정") {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            }
        }
    }
}

extension RunAloneHomeView {
    private var runninModeView: some View {
        HStack(spacing: 7) {
            modeItem(.normal)
            modeItem(.challenge)
            modeItem(.goal)
        }
    }
    private func modeItem(_ mode: RunningMode) -> some View {
        VStack {
            Text(mode.string)
                .font(Fonts.pretendardSemiBold(size: 16))
                .foregroundStyle(store.mode == mode ? .white : .gray300)
        }
        .onTapGesture {
            store.send(.changeMode(mode))
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 8)
        .overlay {
            VStack {
                Spacer()
                Rectangle()
                    .fill(store.mode == mode ? .white : .clear)
                    .frame(height: 2)
            }
        }
        .animation(.easeInOut, value: store.mode)
    }
    private var goalView: some View {
        HStack(spacing: 14) {
            TypeButton(GoalTypeObject(GoalTypes.time))
            TypeButton(GoalTypeObject(GoalTypes.distance))
        }
    }
    private func todayChallengeListView(_ list: [TodayChallenge]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(list.indices, id: \.self) { index in
                    Button(action: {
                        store.send(.selectChallenge(list[index].id))
                    }, label: {
                        TodayChallengeListItemView(challenge: list[index])
                    })
                    .padding(.leading, index == 0 ? 47 : 0)
                    .padding(.trailing, index == list.count-1 ? 47 : 0)
                }
            }
        }
    }
    private var startButton: some View {
        NavigationLink {
            RunningView()
                .navigationBarBackButtonHidden()
        } label: {
            ZStack {
                Circle()
                    .frame(width: 92, height: 92)
                    .foregroundStyle(Color.mainGreen)
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 1, y: 1)
                Text("start")
                    .font(Fonts.pretendardBold(size: 24))
                    .foregroundStyle(Color.background)
            }
        }
    }
}


#Preview {
    RunAloneHomeView()
}
