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
            Text(String(format: "%0" + String(lengthOfTextField(type: store.goalTypeObject.type, isBigGoal: isBigGoal)) + "d", Int(isBigGoal ? store.bigGoal : store.smallGoal) ?? 0))
            TextField("", text: isBigGoal ? $store.bigGoal : $store.smallGoal)
            // MARK: focus 되어있을 때만 cursor를 표시하기 위해 width 1 부여
                .frame(width: isFocus ?? false ? 1 : 0)
                .focused($isFocus, equals: true)
                .keyboardType(.decimalPad)
                .onChange(of: isBigGoal ? store.bigGoal : store.smallGoal) { oldValue, newValue in
                    // MARK: 첫 자리가 0이거나 입력 값중에 숫자 이외의 값이 있는 예외 처리
                    if newValue == "0" || !newValue.allSatisfy({ $0.isNumber }) { store.send(.setGoal(goal: "", isBigGoal: isBigGoal)) }
                    if newValue.count > lengthOfTextField(type: store.goalTypeObject.type, isBigGoal: isBigGoal) {
                        store.send(.setGoal(goal: oldValue, isBigGoal: isBigGoal))  // MARK: 자리수 제한
                    }
                }
            Text(unitOfTextField(type: store.goalTypeObject.type, isBigGoal: isBigGoal))
            Spacer()
        }
        .font(Fonts.pretendardMedium(size: 16))
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .foregroundColor(.gray200)
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

private func lengthOfTextField(type: GoalTypes, isBigGoal: Bool) -> Int {
    return isBigGoal ? 1 : type == .time ? 2 : 3
}
