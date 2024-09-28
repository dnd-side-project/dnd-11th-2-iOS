//
//  RUTabBar.swift
//  RunUs
//
//  Created by seungyooooong on 9/1/24.
//

import SwiftUI

struct RUTabBar: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    
    var body: some View {
        HStack {
            RUDefualtTabItem(.home)
            RUDefualtTabItem(.running)
            RUDefualtTabItem(.myRecord)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 83)
        .background(.white)
    }
    
    private func RUDefualtTabItem(_ tabItem: TabItems) -> some View {
        Button {
            if viewEnvironment.selectedTabItem != tabItem {
                viewEnvironment.selectedTabItem = tabItem
            }
        } label: {
            VStack(spacing: 4) {
                Image(tabItem.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
                    .foregroundStyle(.mainGreen)
                Text(tabItem.name)
            }
        }
        .font(Fonts.pretendardMedium(size: 10))
        .foregroundColor(.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

enum TabItems: String {
    case home
    case running
    case myRecord
    
    var icon: ImageResource {
        switch self {
        case .home:
            return .home
        case .running:
            return .running
        case .myRecord:
            return .chart
        }
    }
    
    var name: String {
        switch self {
        case .home:
            return "HOME"
        case .running:
            return "러닝"
        case .myRecord:
            return "나의기록"
        }
    }
}
