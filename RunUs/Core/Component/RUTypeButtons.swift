//
//  RUTypeButtons.swift
//  RunUs
//
//  Created by seungyooooong on 9/28/24.
//

import Foundation
import SwiftUI

struct RUTypeButtons: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    
    var body: some View {
        HStack(spacing: 14) {
            RUTypeButton(goalType: .time)
            RUTypeButton(goalType: .distance)
        }
    }
    
    private func RUTypeButton(goalType: GoalTypes) -> some View {
        Button {
            let navigationObject = NavigationObject(viewType: .setGoal, data: goalType)
            viewEnvironment.navigationPath.append(navigationObject)
        } label: {
            VStack(spacing: 8) {
                Image(goalType.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(goalType.text)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 138, height: 118)
        .font(Fonts.pretendardBold(size: 15))
        .foregroundColor(.white)
        .background(.mainDeepDark)
        .cornerRadius(12)
    }
}

enum GoalTypes: String, Navigatable {
    case time
    case distance
    
    var text: String {
        switch self {
        case .time:
            return "시간"
        case .distance:
            return "거리"
        }
    }
    
    var icon: ImageResource {
        switch self {
        case .time:
            return .timeIcon
        case .distance:
            return .distanceIcon
        }
    }
}
