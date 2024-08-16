//
//  SetGoalView.swift
//  RunUs
//
//  Created by seungyooooong on 8/11/24.
//

import SwiftUI
import ComposableArchitecture

struct SetGoalView: View {
    let store: StoreOf<SetGoalStore> = Store(
        initialState: SetGoalStore.State(),
        reducer: { SetGoalStore() }
    )
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
            HStack(alignment: .bottom) {
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
    SetGoalView(type: TypeObject(goalType: GoalTypes.distance), bigGoal: "", smallGoal: "")
}

extension SetGoalView {
    private var goalText: some View {
        if bigGoal.count > 0 || smallGoal.count > 0 {
            switch type.type {
            case .time:
                Text("\(bigGoal.count > 0 ? bigGoal + "시간 " : "")\(smallGoal.count > 0 ? smallGoal + "분" : "")")
                    .font(Fonts.pretendardSemiBold(size: 20))
            case .distance:
                Text("\(bigGoal.count > 0 ? bigGoal : "0")\(smallGoal.count > 0 ? "." + smallGoal.formatToKM : "" )km")
                    .font(Fonts.pretendardSemiBold(size: 20))
            }
        } else {
            Text("")
        }
    }
}

extension String {
    public var formatToKM: String {
        switch self.count {
        case 1:
            return "00" + self
        case 2:
            if self.hasSuffix("0") {
                return "0" + String(self.dropLast())
            } else {
                return "0" + self
            }
        case 3:
            if self.hasSuffix("00") {
                return String(self.dropLast(2))
            } else if self.hasSuffix("0") {
                return String(self.dropLast())
            } else {
                return self
            }
        default:
            return self
        }
    }
}

extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
