//
//  RunAloneView.swift
//  RunUs
//
//  Created by Ryeong on 8/5/24.
//

import SwiftUI
import ComposableArchitecture
import MapKit

struct RunAloneView: View {
    @EnvironmentObject var alertEnvironment: AlertEnvironment
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @State var store: StoreOf<RunAloneFeature> = .init(
        initialState: RunAloneFeature.State(),
        reducer: { RunAloneFeature() })
    
    var body: some View {
        VStack(spacing: 0) {
            RUNavigationBar(buttonType: nil, title: "혼자뛰기")
            runninModeView
                .shadow(radius: 4, x: 0, y: 4)
                .zIndex(1)
            ZStack {
                Map(position: $store.userLocation) {
                    UserAnnotation {
                        Image(.userLocationMark)
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                }
                VStack(spacing: 0) {
                    Spacer().frame(height: 64)
                    VStack {
                        // MARK: 모드에 따라 전환되는 화면
                        switch viewEnvironment.selectedRunningMode {
                        case .normal:
                            EmptyView()
                        case .challenge:
                            RUChallengeList(challenges: store.todayChallengeList, listHorizontalPadding: 47)
                                .transition(.scale)
                        case .goal:
                            RUTypeButtons()
                                .transition(.scale)
                        }
                    }
                    Spacer()
                    if viewEnvironment.selectedRunningMode != .goal { startButton.transition(.scale) }
                    Spacer().frame(height: 48)
                }
                .animation(.easeInOut, value: viewEnvironment.selectedRunningMode)
            }
        }
        .navigationBarHidden(true)  // MARK: iOS 18 이후 NavigationStack + Map UI에서 나타나는 NavigationBar 영역을 지우기 위해 필요
        .onAppear {
            store.send(.onAppear(viewEnvironment))
        }
        .onChange(of: store.showLocationPermissionAlert) { oldValue, newValue in
            if newValue {
                alertEnvironment.showAlert(title: Bundle.main.locationString, mainButtonText: "설정", subButtonText: "취소", mainButtonAction: SystemManager.shared.openAppSetting, subButtonAction: self.subButtonAction)
            }
        }
        .onChange(of: viewEnvironment.selectedChallengeIndex) { oldValue, newValue in
            store.send(.selectChallenge(store.todayChallengeList[newValue].id))  // TODO: todayChallengeList에 isSelected 삭제 후 변경
        }
    }
}

extension RunAloneView {
    private var runninModeView: some View {
        HStack(spacing: 7) {
            modeItem(.normal)
            modeItem(.challenge)
            modeItem(.goal)
        }
        .frame(maxWidth: .infinity)
        .background(Color.background)
    }
    private func modeItem(_ mode: RunningMode) -> some View {
        VStack {
            Text(mode.string)
                .font(Fonts.pretendardSemiBold(size: 16))
                .foregroundStyle(viewEnvironment.selectedRunningMode == mode ? .white : .gray300)
        }
        .onTapGesture {
            viewEnvironment.selectedRunningMode = mode
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 8)
        .overlay {
            VStack {
                Spacer()
                Rectangle()
                    .fill(viewEnvironment.selectedRunningMode == mode ? .white : .clear)
                    .frame(height: 2)
            }
        }
        .animation(.easeInOut, value: viewEnvironment.selectedRunningMode)
    }
    private var startButton: some View {
        Button {
            store.send(.startButtonTapped)
        } label: {
            ZStack {
                Circle()
                    .frame(width: 92, height: 92)
                    .foregroundStyle(Color.mainGreen)
                    .shadow(color: .black.opacity(0.7),radius: 10, x: 0, y: 0)
                    .zIndex(1)
                Text("start")
                    .font(Fonts.pretendardBold(size: 24))
                    .foregroundStyle(Color.background)
                    .zIndex(2)
            }
        }
    }
    private func subButtonAction() {
        store.send(.locationPermissionAlertChanged(false))
        alertEnvironment.dismiss()
    }
}


#Preview {
    RunAloneView()
        .environmentObject(AlertEnvironment())
        .environmentObject(ViewEnvironment())
}
