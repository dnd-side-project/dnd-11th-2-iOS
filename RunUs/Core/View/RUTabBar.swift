//
//  RUTabBar.swift
//  RunUs
//
//  Created by seungyooooong on 9/1/24.
//

import SwiftUI

struct RUTabBar: View {
    var body: some View {
        HStack {
            RUDefualtTabItem(tabItemObject: TabItemObject(TabItems.home))
            RUDefualtTabItem(tabItemObject: TabItemObject(TabItems.running))
            RUDefualtTabItem(tabItemObject: TabItemObject(TabItems.myRecord))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 83)
        .background(.white)
    }
}

private func RUDefualtTabItem(tabItemObject: TabItemObject) -> some View {
    Button {
        UserDefaultManager.selectedTabItem = tabItemObject.tabItem.rawValue
    } label: {
        VStack(spacing: 4) {
            Image(tabItemObject.icon)
                .resizable()
                .scaledToFit()
                .frame(height: 24)
            Text(tabItemObject.name)
        }
    }
    .font(Fonts.pretendardMedium(size: 10))
    .foregroundColor(.black)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}


enum TabItems: String {
    case home
    case running
    case myRecord
}

struct TabItemObject {
    let tabItem: TabItems
    let icon: ImageResource
    let name: String
    
    init(_ tabItem: TabItems) {
        self.tabItem = tabItem
        switch tabItem {
        case .home:
            self.icon = .home
            self.name = "HOME"
        case .running:
            self.icon = .running
            self.name = "러닝"
        case .myRecord:
            self.icon = .chart
            self.name = "나의기록"
        }
    }
}

#Preview {
    RUTabBar()
}
