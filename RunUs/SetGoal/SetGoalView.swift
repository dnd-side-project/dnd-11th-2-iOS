//
//  SetGoalView.swift
//  RunUs
//
//  Created by seungyooooong on 8/11/24.
//

import SwiftUI
import ComposableArchitecture

struct SetGoalView: View {
    @EnvironmentObject var alertEnvironment: AlertEnvironment
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @State var store: StoreOf<SetGoalStore>
    
    init(_ goalType: GoalTypes) {
        self.store = Store(
            initialState: SetGoalStore.State(goalType: goalType),
            reducer: { SetGoalStore() }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                RUNavigationBar(buttonType: .back, title: "목표설정")
                Spacer().frame(height: 29)
                Text("목표 설정하기 🏃")
                    .font(Fonts.pretendardBold(size: 24))
                Spacer().frame(height: 25)
                Text("오늘 달리며 달성할 \(goalTypeString(store.goalType)) 직접 설정해보세요.")
                    .font(Fonts.pretendardRegular(size: 16))
                Spacer().frame(height: 87)
                Text(store.goalType.text)
                    .font(Fonts.pretendardSemiBold(size: 16))
                Spacer().frame(height: 12)
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
                .blur(radius: store.isShowValidateToast ? 5.5 : 0)
                .overlay {
                    if store.isShowValidateToast {
                        validateToast
                    }
                }
                .animation(.easeInOut, value: store.isShowValidateToast)
                Spacer().frame(height: 36)
            }
            .padding(.horizontal, Paddings.outsideHorizontalPadding)
            .background(Color.background)
            .onTapGesture {
                hideKeyboard()
            }
            RUButton(
                action: {
                    store.send(.runningStart)
                }, text: "목표 설정 완료"
                , disableCondition: store.bigGoal.count == 0 && store.smallGoal.count == 0
            )
            .padding(.horizontal, Paddings.outsideHorizontalPadding)
            .background(Color.background)
        }
        .foregroundStyle(.white)
        .onAppear {
            store.send(.onAppear(viewEnvironment))
        }
        .onChange(of: store.showLocationPermissionAlert, { oldValue, newValue in
            if newValue {
                alertEnvironment.showAlert(title: Bundle.main.locationString, mainButtonText: "설정", subButtonText: "취소", mainButtonAction: SystemManager.shared.openAppSetting, subButtonAction: self.subButtonAction)
            }
        })
    }
}

#Preview {
    SetGoalView(.distance)
        .environmentObject(AlertEnvironment())
        .environmentObject(ViewEnvironment())
}

extension SetGoalView {
    private func goalTypeString(_ goalType: GoalTypes) -> String {
        return goalType == .time ? goalType.text + "을" : goalType.text + "를"
    }
    private var goalText: some View {
        if store.bigGoal.count > 0 || store.smallGoal.count > 0 {
            switch store.goalType {
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
    private func subButtonAction() {
        store.send(.locationPermissionAlertChanged(false))
        alertEnvironment.dismiss()
    }
    private var validateToast: some View {
        HStack(spacing: 4) {
            Image(.warning)
                .resizable()
                .scaledToFit()
                .frame(width: 17, height: 17)
            Text(store.validateString)
                .font(Fonts.pretendardRegular(size: 12))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 55)
        .background(.black.opacity(0.7))
        .cornerRadius(8)
    }
}
    
