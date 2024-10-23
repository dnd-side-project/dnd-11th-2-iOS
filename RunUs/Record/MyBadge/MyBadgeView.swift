//
//  MyBadgeView.swift
//  RunUs
//
//  Created by seungyooooong on 10/23/24.
//

import SwiftUI
import ComposableArchitecture

struct MyBadgeView: View {
    @State var store: StoreOf<MyBadgeStore> = Store(
        initialState: MyBadgeStore.State(),
        reducer: { MyBadgeStore() }
    )
    
    var body: some View {
        ViewThatFits(in: .vertical) {
            myBadgeView
            ScrollView {
                myBadgeView
            }
        }
        .padding(.top, 1)   // MARK: ViewThatFits에서 ScrollView를 사용하면 SafeArea를 유지하기 위해 필요
        .background(Color.background)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

extension MyBadgeView {
    private var myBadgeView: some View {
        VStack(spacing: 0) {
            RUNavigationBar(buttonType: .back, title: "나의뱃지")
            RUTitle(text: "신규 뱃지")
            RUBadgeList(badges: store.badgeLists.recencyBadges)
            RUTitle(text: "개인 기록")
            RUBadgeList(badges: store.badgeLists.personalBadges)
            RUTitle(text: "러닝 거리")
            RUBadgeList(badges: store.badgeLists.distanceBadges)
            RUTitle(text: "streak")
            RUBadgeList(badges: store.badgeLists.streakBadges)
            RUTitle(text: "duration")
            RUBadgeList(badges: store.badgeLists.durationBadges)
            RUTitle(text: "level")
            RUBadgeList(badges: store.badgeLists.levelBadges)
            Spacer()
        }
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
    }
}

#Preview {
    MyBadgeView()
}
