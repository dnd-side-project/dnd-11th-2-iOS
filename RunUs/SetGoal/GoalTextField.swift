//
//  GoalTextField.swift
//  RunUs
//
//  Created by seungyooooong on 8/12/24.
//

import SwiftUI
import ComposableArchitecture

struct GoalTextField: View {
    @FocusState private var isFocus: Bool?
    @State var store: StoreOf<SetGoalStore>
    let isBigGoal: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            TextField("", text: isBigGoal ? $store.bigGoal : $store.smallGoal)
                .multilineTextAlignment(.trailing)
                .focused($isFocus, equals: true)
                .keyboardType(.decimalPad)
                .onChange(of: isBigGoal ? store.bigGoal : store.smallGoal) { oldValue, newValue in
                    // MARK: 첫 자리가 0이거나 입력 값중에 숫자 이외의 값이 있는 예외 처리
                    if newValue == "0" || !newValue.allSatisfy({ $0.isNumber }) { store.send(.setGoal(goal: "", isBigGoal: isBigGoal)) }
                    if let newValue = Int(newValue), newValue > maxOfNum(type: store.goalType) {
                        store.send(.setGoal(goal: String(maxOfNum(type: store.goalType)), isBigGoal: isBigGoal))
                        store.send(.showValidateToast(isBigGoal: isBigGoal))
                    }
                }
            Text(unitOfTextField(type: store.goalType, isBigGoal: isBigGoal))
            Spacer()
        }
        .font(Fonts.pretendardMedium(size: 16))
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .foregroundColor(.white)
        .background(.mainDeepDark)
        .cornerRadius(8)
        .frame(height: 48)
        .onTapGesture {
            isFocus = true
        }
    }
}

private func unitOfTextField(type: GoalTypes, isBigGoal: Bool) -> String {
    switch type {
    case .time:
        return isBigGoal ? "시간" : "분"
    case .distance:
        return isBigGoal ? "km" : "m"
    }
}

private func maxOfNum(type: GoalTypes) -> Int {
    return type == .distance ? 999 : 59
}
