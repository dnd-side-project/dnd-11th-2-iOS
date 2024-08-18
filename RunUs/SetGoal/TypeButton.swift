//
//  TypeButton.swift
//  RunUs
//
//  Created by seungyooooong on 8/12/24.
//

import SwiftUI

// TODO: #33(혼자 뛰기 홈화면 디자인 개편)시 폴더 이동
struct TypeButton: View {
    let typeObject: TypeObject
    
    var body: some View {
        NavigationLink {
            SetGoalView(typeObject: typeObject)
                .navigationBarBackButtonHidden()
        } label: {
            VStack(spacing: 8) {
                Image(typeObject.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(typeObject.text)
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
    TypeButton(typeObject: TypeObject(goalType: GoalTypes.distance))
}
