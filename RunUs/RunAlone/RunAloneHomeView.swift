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
                            todayChallengeView(isOn: $store.todayChallengeToggle)
                        }
                        .padding(.horizontal, Paddings.outsideHorizontalPadding)
                        .background(Color.background)
                        
                        if store.todayChallengeToggle {
                            Spacer()
                                .frame(height: 34)
                            todayChallengeListView(store.todayChallengeList)
                        }
                        Spacer()
                        startButton
                        Spacer()
                            .frame(height: 95)
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
    
    private var startButton: some View {
        NavigationLink {
            RunningView(store: .init(
                initialState: RunningFeature.State(
                    challengeId: 0,
                    goalDistance: 0,
                    goalTime: 0,
                    achievementMode: "normal"),
                reducer: {
                RunningFeature()
            }))
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
    
    private func todayChallengeView(isOn: Binding<Bool>) -> some View {
        HStack {
            Text("오늘의 챌린지")
                .font(Fonts.pretendardMedium(size: 16))
                .foregroundStyle(.white)
            Spacer()
            Toggle("", isOn: isOn)
        }
        .frame(height: 80)
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
}


#Preview {
    RunAloneHomeView()
}
