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
    let store: StoreOf<SetGoalStore>
    let isBigGoal: Bool
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack(spacing: 0) {
                Text(String(format: "%0" + String(lengthOfTextField(type: viewStore.goalTypeObject.type, isBigGoal: isBigGoal)) + "d", Int(isBigGoal ? viewStore.bigGoal : viewStore.smallGoal) ?? 0))
                TextField("", text: isBigGoal ? viewStore.$bigGoal : viewStore.$smallGoal)
                // MARK: focus 되어있을 때만 cursor를 표시하기 위해 width 1 부여
                    .frame(width: isFocus ?? false ? 1 : 0)
                    .focused($isFocus, equals: true)
                    .keyboardType(.decimalPad)
                    .onChange(of: isBigGoal ? viewStore.bigGoal : viewStore.smallGoal) { oldValue, newValue in
                        if newValue == "0" { viewStore.send(.setGoal(goal: "", isBigGoal: isBigGoal)) }    // MARK: 첫 자리는 0일 수 없도록 처리
                        if newValue.count > lengthOfTextField(type: viewStore.goalTypeObject.type, isBigGoal: isBigGoal) {
                            viewStore.send(.setGoal(goal: oldValue, isBigGoal: isBigGoal))
                        }
                    }
                Text(unitOfTextField(type: viewStore.goalTypeObject.type, isBigGoal: isBigGoal))
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
