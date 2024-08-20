//
//  MyBadges.swift
//  RunUs
//
//  Created by seungyooooong on 8/20/24.
//

import SwiftUI

struct MyBadges: View {
    let badges: [BadgesResponseModel]
    
    var body: some View {
        HStack(spacing: 0) {
            if badges.count == 0 {
                Text("달리기를 시작하고 뱃지를 받아보세요!")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray200)
                    .padding(8)
                Image(.noBadgeIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 82)
            } else {
                // TODO: 미리 보기 뱃지 갯수 정의 (ex: 미리 보기 뱃지는 3개로 고정) 이후 수정
                VStack {
                    ForEach (0 ... (badges.count / 3), id: \.self) { rowIndex in
                        HStack(spacing: 0) {
                            MyBadge(badge: badges[rowIndex * 3])
                            MyBadge(badge: badges.count > rowIndex * 3 + 1 ? badges[rowIndex * 3 + 1] : nil)
                            MyBadge(badge: badges.count > rowIndex * 3 + 2 ? badges[rowIndex * 3 + 2] : nil)
                        }
                    }
                }
            }
        }
        .padding(.bottom, 24)
    }
}

struct MyBadge: View {
    let badge: BadgesResponseModel?
    
    var body: some View {
        VStack(spacing: 0) {
            if badge == nil {
                Image(.xmark)  // MARK: empty Image
                    .resizable()
                    .scaledToFit()
                    .padding(50)
                    .opacity(0)
            } else {
                Image(.splash)  // TODO: 서버에서 받는 이미지 URL로 수정 필요
                    .resizable()
                    .scaledToFit()
                    .padding(25)
                Text(badge!.name)
                    .font(.system(size: 12))
                    .foregroundStyle(.gray200)
            }
        }
    }
}

#Preview {
    MyBadges(badges: [BadgesResponseModel(), BadgesResponseModel()])
        .background(Color.background)
}
