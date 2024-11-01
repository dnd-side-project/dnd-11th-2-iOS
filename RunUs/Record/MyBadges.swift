//
//  MyBadges.swift
//  RunUs
//
//  Created by seungyooooong on 8/20/24.
//

import SwiftUI

struct MyBadges: View {
    let badges: [Badge]
    
    var body: some View {
        HStack(spacing: 0) {
            if badges.count == 0 {
                Text("달리기를 시작하고 뱃지를 받아보세요!")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray200)
                    .padding(8)
                Image(.Record.noBadge)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 82)
            } else {
                // TODO: 미리 보기 뱃지 갯수 정의 (ex: 미리 보기 뱃지는 3개로 고정) 이후 수정
                VStack {
                    ForEach (0 ... ((badges.count - 1) / 3), id: \.self) { rowIndex in
                        HStack(spacing: 3) {
                            MyBadge(badge: badges[rowIndex * 3])
                            MyBadge(badge: badges.count > rowIndex * 3 + 1 ? badges[rowIndex * 3 + 1] : nil)
                            MyBadge(badge: badges.count > rowIndex * 3 + 2 ? badges[rowIndex * 3 + 2] : nil)
                        }
                    }
                }
            }
        }
        Spacer().frame(height: 24)
    }
}

struct MyBadge: View {
    let badge: Badge?
    
    var body: some View {
        VStack(spacing: 0) {
            if badge == nil {
                Image(.menuXmark)  // MARK: empty Image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .opacity(0)
            } else {
                AsyncImage(url: URL(string: badge!.imageUrl)) { image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .aspectRatio(1, contentMode: .fit)
                .padding(13)
                Text(badge!.name)
                    .font(.system(size: 12))
                    .foregroundStyle(.gray200)
            }
        }
    }
}

#Preview {
    MyBadges(badges: [])
        .background(Color.background)
}
