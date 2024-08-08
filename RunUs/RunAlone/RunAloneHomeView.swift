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
    let store: StoreOf<RunAloneHomeFeature> = .init(
        initialState: RunAloneHomeFeature.State(),
        reducer: { RunAloneHomeFeature() })
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Map()
                VStack(spacing: 53) {
                    VStack(spacing: 0) {
                        RUNavigationBar(buttonType: .back,
                                        title: "혼자뛰기")
                        todayChallengeView(isOn: viewStore.$todayChallengeToggle)
                    }
                    if viewStore.todayChallengeToggle {
                        todayChallengeCardView(viewStore.todayChallengeList)
                    }
                    Spacer()
                }
                
            }
            .onAppear {
                store.send(.onAppear)
            }
            .alert(Bundle.main.locationString,
                   isPresented: viewStore.$showLocationPermissionAlert) {
                Button("취소", role: .cancel) {
                    
                }
                Button("설정", role: .destructive) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            }
        }
    }
}

extension RunAloneHomeView {
    private func todayChallengeView(isOn: Binding<Bool>) -> some View {
        HStack {
            Text("오늘의 챌린지")
                .font(Fonts.pretendardMedium(size: 16))
                .foregroundStyle(.white)
            Spacer()
            Toggle("", isOn: isOn)
        }
        .frame(height: 80)
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
        .background(.background)
        .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
    }
    
    private func todayChallengeCardView(_ list: [TodayChallenge]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(list.indices, id: \.self) { index in
                    Button(action: {
                        store.send(.selectedChallengeChanged(list[index].id))
                    }, label: {
                        ChallengeCell(challenge: list[index])
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
