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
            RUDefualtTabItem(viewEnvironment, TabItemObject(TabItems.home))
            RUDefualtTabItem(viewEnvironment, TabItemObject(TabItems.running))
            RUDefualtTabItem(viewEnvironment, TabItemObject(TabItems.myRecord))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 83)
        .background(.white)
    }
}

private func RUDefualtTabItem(_ viewEnvironment: ViewEnvironment, _ tabItemObject: TabItemObject) -> some View {
    Button {
        if viewEnvironment.selectedTabItem != tabItemObject.tabItem {
            viewEnvironment.selectedTabItem = tabItemObject.tabItem
        }
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
