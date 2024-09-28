//
//  RUTypeButtons.swift
//  RunUs
//
//  Created by seungyooooong on 9/28/24.
//

import Foundation
import SwiftUI

struct RUTypeButtons: View {
    var body: some View {
        HStack(spacing: 14) {
            TypeButton(GoalTypeObject(GoalTypes.time))
            TypeButton(GoalTypeObject(GoalTypes.distance))
        }
    }
}

struct TypeButton: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    let goalTypeObject: GoalTypeObject
    
    init(_ goalTypeObject: GoalTypeObject) {
        self.goalTypeObject = goalTypeObject
    }
    
    var body: some View {
        Button {
            let navigationObject = NavigationObject(viewType: .setGoal, data: goalTypeObject)
            viewEnvironment.navigationPath.append(navigationObject)
        } label: {
            VStack(spacing: 8) {
                Image(goalTypeObject.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(goalTypeObject.text)
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

enum GoalTypes: String {
    case time
    case distance
}

struct GoalTypeObject: Equatable, Navigatable {
    let type: GoalTypes
    let text: String
    let icon: ImageResource
    
    init(_ goalType: GoalTypes) {
        self.type = goalType
        switch goalType {
        case .time:
            self.text = "시간"
            self.icon = .timeIcon
        case .distance:
            self.text = "거리"
            self.icon = .distanceIcon
        }
    }
}
