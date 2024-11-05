//
//  RUBadgeList.swift
//  RunUs
//
//  Created by seungyooooong on 10/23/24.
//

import SwiftUI

struct RUBadgeList: View {
    let badges: [Badge]
    
    var body: some View {
        HStack(spacing: 0) {
            if badges.count == 0 {
                Text("달리기를 시작하고 뱃지를 받아보세요!")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray200)
                    .padding(8)
                    .frame(height: 82)
            } else {
                let rowLimit = (badges.count - 1) / 3 + 1
                VStack {
                    ForEach (0 ..< rowLimit, id: \.self) { rowIndex in
                        HStack(spacing: 3) {
                            RUBadge(badge: badges[rowIndex * 3])
                            RUBadge(badge: badges.count > rowIndex * 3 + 1 ? badges[rowIndex * 3 + 1] : nil)
                            RUBadge(badge: badges.count > rowIndex * 3 + 2 ? badges[rowIndex * 3 + 2] : nil)
                        }
                    }
                }
            }
        }
    }
}

struct RUBadge: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    let badge: Badge?
    
    var body: some View {
        let isShowDetail = viewEnvironment.navigationPath.last?.viewType == .myBadge
        if isShowDetail {
            ruBadge // TODO: 추후 뱃지 획득일 등 상세 내용을 보여주도록 수정
        } else {
            Button {
                let navigationObject = NavigationObject(viewType: .myBadge)
                viewEnvironment.navigate(navigationObject)
            } label: {
                ruBadge
            }
        }
    }
    
    private var ruBadge: some View {
        VStack(spacing: 0) {
            if let badge = badge {
                AsyncImage(url: URL(string: badge.imageUrl)) { image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .aspectRatio(1, contentMode: .fit)
                .padding(13)
                Text(badge.name)
                    .font(.system(size: 12))
                    .foregroundStyle(.gray200)
            } else {
                Image(.menuXmark)  // MARK: empty Image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .opacity(0)
            }
        }
    }
}

#Preview {
    RUBadgeList(badges: [])
        .background(Color.background)
}
