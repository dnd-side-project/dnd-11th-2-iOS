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
    @Environment(\.dismiss) var dismiss
    let buttonType: NavigationButtonType?
    let title: String
    
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
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
        .frame(height: 56)
        .background(Colors.background)
    }
}

extension RUNavigationBar {
    private var button: some View {
        Group {
            switch buttonType {
            case .back:
                backButton
            case .home:
                backButton
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
    private var titleText: some View {
        Text(title)
            .bold()
            .font(.system(size: 18))
            .foregroundStyle(.white)
    }
}

#Preview {
    RUNavigationBar(buttonType: .back, title: "목표설정")
}
