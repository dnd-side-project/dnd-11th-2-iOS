//
//  SplashView.swift
//  RunUs
//
//  Created by seungyooooong on 7/22/24.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var alertEnvironment: AlertEnvironment
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack {
            Image(.runusSplash)
                .resizable()
                .scaledToFit()
                .frame(width: 79)
        }
        .onAppear {
            Task {
                guard let version = SystemManager.appVersion else {
                    return
                }
                let isUpdateRequired = try await SystemManager.shared.getServerVersion(version: version)
                if isUpdateRequired {
                    alertEnvironment.showAlert(
                        title: "런어스가 업데이트 되었어요!",
                        subTitle: "안정적인 사용을 위해\n최신버전으로 업데이트해주세요.",
                        mainButtonText: "업데이트",
                        subButtonText: "앱 종료",
                        mainButtonAction: SystemManager.shared.openAppStore,
                        subButtonAction: SystemManager.shared.terminateApp
                    )
                } else {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                        DispatchQueue.main.async {
                            isLoading = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView(isLoading: .constant(true))
        .background(Color.background)
}
