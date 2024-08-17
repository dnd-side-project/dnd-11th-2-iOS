//
//  SetGoalView.swift
//  RunUs
//
//  Created by seungyooooong on 8/11/24.
//

import SwiftUI

struct SetGoalView: View {
    let type: TypeObject
    @State var bigGoal: String = ""
    @State var smallGoal: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RUNavigationBar(buttonType: .back, title: "목표설정")
                .padding(.bottom, 29)
            Text("목표 설정하기 🏃")
                .font(Fonts.pretendardBold(size: 24))
                .padding(.bottom, 25)
            Text("오늘 달리며 달성할 \(type.type == .time ? type.text + "을" : type.text + "를") 직접 설정해보세요.")
                .font(Fonts.pretendardRegular(size: 16))
                .padding(.bottom, 87)
            Text(type.text)
                .font(Fonts.pretendardSemiBold(size: 16))
                .padding(.bottom, 12)
            HStack(spacing: 8) {
                GoalTextField(type: type, goal: $bigGoal, isBigGoal: true)
                GoalTextField(type: type, goal: $smallGoal, isBigGoal: false)
            }
            Spacer()
            HStack {
                Text("달리기 목표 달성량")
                    .font(Fonts.pretendardRegular(size: 15))
                Spacer()
                goalText
            }
            .padding(.bottom, 36)
            RUButton(action: {
                // TODO: CountDownView로 넘어가도록 구현
            }, text: "목표 설정 완료")
        }
        .foregroundStyle(.white)
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
        .background(Color.background)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    SetGoalView(type: TypeObject(goalType: GoalTypes.distance), bigGoal: "2", smallGoal: "")
}

extension SetGoalView {
    private var goalText: some View {
        if bigGoal.count > 0 || smallGoal.count > 0 {
            switch type.type {
            case .time:
                Text("\(bigGoal.count > 0 ? bigGoal + "시간 " : "")\(smallGoal.count > 0 ? smallGoal + "분" : "")")
                    .font(Fonts.pretendardSemiBold(size: 20))
            case .distance:
                Text("\(bigGoal.count > 0 ? bigGoal : "0")\(smallGoal.count > 0 ? "." + formatString(smallGoal) : "" )km")
                    .font(Fonts.pretendardSemiBold(size: 20))
            }
        } else {
            Text("")
        }
    }
}

private func formatString(_ input: String) -> String {
    let count = input.count
    
    switch count {
    case 1:
        return "00" + input
    case 2:
        if input.hasSuffix("0") {
            return "0" + String(input.dropLast())
        } else {
            return "0" + input
        }
    case 3:
        if input.hasSuffix("00") {
            return String(input.dropLast(2))
        } else if input.hasSuffix("0") {
            return String(input.dropLast())
        } else {
            return input
        }
    default:
        return input
    }
}

extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
