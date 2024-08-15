//
//  SelectTypeView.swift
//  RunUs
//
//  Created by seungyooooong on 8/12/24.
//

import SwiftUI

struct SelectTypeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RUNavigationBar(buttonType: .back, title: "목표설정")
                .padding(.bottom, 29)
            Text("목표 설정하기 🏃")
                .font(Fonts.pretendardBold(size: 24))
                .padding(.bottom, 25)
            Text("오늘 달리며 달성할 시간과 거리를 직접 설정해보세요.")
                .font(Fonts.pretendardRegular(size: 16))
                .padding(.bottom, 78)
            HStack(spacing: 16) {
                TypeButton(type: TypeObject(goalType: GoalTypes.time))
                TypeButton(type: TypeObject(goalType: GoalTypes.distance))
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
        .background(Color.background)
    }
}

#Preview {
    SelectTypeView()
}
