//
//  SetGoalView.swift
//  RunUs
//
//  Created by seungyooooong on 8/11/24.
//

import SwiftUI
import ComposableArchitecture

struct SetGoalView: View {
    let store: StoreOf<SetGoalStore>
    
    init(_ goalTypeObject: GoalTypeObject) {
        self.store = Store(
            initialState: SetGoalStore.State(goalTypeObject: goalTypeObject),
            reducer: { SetGoalStore() }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RUNavigationBar(buttonType: .back, title: "목표설정")
                .padding(.bottom, 29)
            Text("목표 설정하기 🏃")
                .font(Fonts.pretendardBold(size: 24))
                .padding(.bottom, 25)
            Text("오늘 달리며 달성할 \(goalTypeString(store.goalTypeObject)) 직접 설정해보세요.")
                .font(Fonts.pretendardRegular(size: 16))
                .padding(.bottom, 87)
            Text(store.goalTypeObject.text)
                .font(Fonts.pretendardSemiBold(size: 16))
                .padding(.bottom, 12)
            HStack(spacing: 8) {
                GoalTextField(store: store, isBigGoal: true)
                GoalTextField(store: store, isBigGoal: false)
            }
            Spacer()
            HStack(alignment: .bottom) {
                Text("달리기 목표 달성량")
                    .font(Fonts.pretendardRegular(size: 15))
                Spacer()
                goalText
            }
            .padding(.bottom, 36)
            RUButton(
                action: {
                    // TODO: 러닝 화면으로 넘어가도록 구현
                }, text: "목표 설정 완료"
                , disableCondition: store.bigGoal.count == 0 && store.smallGoal.count == 0
            )
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
    SetGoalView(GoalTypeObject(GoalTypes.distance))
}

extension SetGoalView {
    private func goalTypeString(_ typeObject: GoalTypeObject) -> String {
        return typeObject.type == .time ? typeObject.text + "을" : typeObject.text + "를"
    }
    private var goalText: some View {
        if store.bigGoal.count > 0 || store.smallGoal.count > 0 {
            switch store.goalTypeObject.type {
            case .time:
                Text("\(store.bigGoal.count > 0 ? store.bigGoal + "시간 " : "")\(store.smallGoal.count > 0 ? store.smallGoal + "분" : "")")
                    .font(Fonts.pretendardSemiBold(size: 20))
            case .distance:
                Text("\(store.bigGoal.count > 0 ? store.bigGoal : "0")\(store.smallGoal.count > 0 ? "." + store.smallGoal.formatToKM : "" )km")
                    .font(Fonts.pretendardSemiBold(size: 20))
            }
        } else {
            Text("")
        }
    }
}