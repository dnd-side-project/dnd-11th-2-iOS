//
//  GoalTextField.swift
//  RunUs
//
//  Created by seungyooooong on 8/12/24.
//

import SwiftUI

struct GoalTextField: View {
    var type: TypeObject
    @Binding var goal: String
    let isBigGoal: Bool
    @FocusState private var isFocus: Bool?
    
    var body: some View {
        HStack(spacing: 0) {
            Text(String(format: "%0" + String(lengthOfTextField(type: type, isBigGoal: isBigGoal)) + "d", Int(goal) ?? 0))
            TextField("", text: $goal)
            // MARK: focus 되어있을 때만 cursor를 표시하기 위해 width 1 부여
                .frame(width: isFocus ?? false ? 1 : 0)
                .focused($isFocus, equals: true)
                .keyboardType(.decimalPad)
                .onChange(of: goal) { oldValue, newValue in
                    if newValue == "0" { goal = "" }    // MARK: 첫 자리는 0일 수 없도록 처리
                    if newValue.count > lengthOfTextField(type: type, isBigGoal: isBigGoal) {
                        goal = oldValue
                    }
                }
            Text(unitOfTextField(type: type, isBigGoal: isBigGoal))
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

#Preview {
    GoalTextField(type: TypeObject(goalType: GoalTypes.time), goal: .constant(""), isBigGoal: true)
}

private func unitOfTextField(type: TypeObject, isBigGoal: Bool) -> String {
    switch type.type {
    case .time:
        return isBigGoal ? "시간" : "분"
    case .distance:
        return isBigGoal ? "km" : "m"
    }
}

private func lengthOfTextField(type: TypeObject, isBigGoal: Bool) -> Int {
    return isBigGoal ? 1 : type.type == .time ? 2 : 3
}
