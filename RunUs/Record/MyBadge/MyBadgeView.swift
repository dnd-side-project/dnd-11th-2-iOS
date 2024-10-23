//
//  MyBadgeView.swift
//  RunUs
//
//  Created by seungyooooong on 10/23/24.
//

import SwiftUI

struct MyBadgeView: View {
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
            
        }
    }
}

extension MyBadgeView {
    private var myBadgeView: some View {
        VStack(spacing: 0) {
            RUNavigationBar(buttonType: .back, title: "나의뱃지")
            RUTitle(text: "신규 뱃지")
            RUBadgeList(badges: [])
            RUTitle(text: "개인 기록")
            RUBadgeList(badges: [])
            RUTitle(text: "러닝 거리")
            RUBadgeList(badges: [])
            RUTitle(text: "streak")
            RUBadgeList(badges: [])
            RUTitle(text: "duration")
            RUBadgeList(badges: [])
            RUTitle(text: "level")
            RUBadgeList(badges: [])
            Spacer()
        }
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
    }
}

#Preview {
    MyBadgeView()
}
