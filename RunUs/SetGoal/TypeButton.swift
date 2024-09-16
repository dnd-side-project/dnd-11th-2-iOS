//
//  TypeButton.swift
//  RunUs
//
//  Created by seungyooooong on 8/12/24.
//

import SwiftUI

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

#Preview {
    TypeButton(GoalTypeObject(GoalTypes.distance))
}
