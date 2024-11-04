//
//  AlertManager.swift
//  RunUs
//
//  Created by seungyooooong on 11/3/24.
//

import Foundation
import SwiftUI

class AlertManager: ObservableObject {
    static let shared = AlertManager()
    private init() { }
    
    @Published private(set) var isShowAlert = false
    @Published var ruAlert: RUAlert = RUAlert(title: "", subTitle: "", mainButtonText: "확인", subButtonText: "취소", mainButtonColor: .mainGreen, mainButtonAction: {}, subButtonAction: {})
    
    private var retryAPIs: Array<() -> Void> = []
    
    func showAlert(
        title: String,
        subTitle: String = "",
        mainButtonText: String = "확인",
        subButtonText: String = "취소",
        mainButtonColor: Color = .mainGreen,
        mainButtonAction: (() -> Void)? = nil,
        subButtonAction: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            self.ruAlert = RUAlert(
                title: title,
                subTitle: subTitle,
                mainButtonText: mainButtonText,
                subButtonText: subButtonText,
                mainButtonColor: mainButtonColor,
                mainButtonAction: mainButtonAction ?? self.dismiss,
                subButtonAction: subButtonAction ?? self.dismiss
            )
            self.isShowAlert = true
        }
    }
    func dismiss() {
        DispatchQueue.main.async {
            self.isShowAlert = false
        }
    }
    
    func showNetworkAlert(_ api: @escaping () -> Void) {
        self.appendAPI(api)
        self.showAlert(
            title: "서비스가 일시적으로 이용불가합니다.\n잠시 후 다시 시도해주세요",
            mainButtonText: "다시 시도하기",
            subButtonText: "앱 종료",
            mainButtonAction: {
                self.dismiss()
                self.retryAll()
            },
            subButtonAction: {
                SystemManager.shared.terminateApp()
            }
        )
    }
    func appendAPI(_ api: @escaping () -> Void) {
        self.retryAPIs.append(api)
    }
    func retryAll() {
        retryAPIs.forEach { api in
            api()
        }
        retryAPIs.removeAll()
    }
}
