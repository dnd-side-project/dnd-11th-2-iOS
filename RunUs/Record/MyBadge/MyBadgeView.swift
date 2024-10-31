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
        VStack(spacing: .zero) {
            RUNavigationBar(buttonType: .back, title: "나의뱃지")
            ViewThatFits(in: .vertical) {
                myBadgeView
                ScrollView {
                    myBadgeView
                }
            }
        }
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
        .background(Color.background)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

extension MyBadgeView {
    private var myBadgeView: some View {
        VStack(spacing: .zero) {
            RUTitle(text: "신규 뱃지")
            RUBadgeList(badges: store.badgeLists.recencyBadges)
            ForEach(store.badgeLists.badgesList, id: \.self) { badgeList in
                RUTitle(text: badgeList.category)
                RUBadgeList(badges: badgeList.badges)
            }
            Spacer()
        }
    }
}

#Preview {
    MyBadgeView()
}
