//
//  RUNavigationBarView.swift
//  RunUs
//
//  Created by Ryeong on 8/7/24.
//

import SwiftUI

enum NavigationButtonType {
    case back
    case home
}

struct RUNavigationBar: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @Environment(\.dismiss) var dismiss
    let buttonType: NavigationButtonType?
    let title: String
    
    init(buttonType: NavigationButtonType?, title: String) {
        self.buttonType = buttonType
        self.title = title
    }
    
    var body: some View {
        HStack {
            button
            Spacer()
            Text(title)
                .bold()
                .font(.system(size: 18))
                .foregroundStyle(.white)
            Spacer()
            button.opacity(0)
        }
        .frame(height: 56)
        .background(Color.background)
    }
}

extension RUNavigationBar {
    private var button: some View {
        Group {
            switch buttonType {
            case .back:
                backButton
            case .home:
                homeButton
            case .none:
                EmptyView()
            }
        }
    }
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(.chevronLeft)
        }
    }
    
    private var homeButton: some View {
        Button {
            viewEnvironment.reset()
        } label: {
            Image(.home)
                .resizable()
                .frame(width: 24, height: 24)
                .tint(.white)
        }
    }
    
    private var titleText: some View {
        Text(title)
            .bold()
            .font(.system(size: 18))
            .foregroundStyle(.white)
    }
}

#Preview {
    RUNavigationBar(buttonType: .home, title: "목표설정")
}
