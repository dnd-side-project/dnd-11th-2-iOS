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
    @Published var ruAlert: RUAlert = RUAlert(title: "", subTitle: "", mainButtonText: "확인", subButtonText: "취소", mainButtonColor: .mainGreen, mainButtonAction: {}, subButtonAction: {}, isSingleButtonAlert: false)
    
    private var retryAPIs: Array<() -> Void> = []
    
    func showAlert(
        imageUrl: String? = nil,
        title: String,
        subTitle: String = "",
        mainButtonText: String = "확인",
        subButtonText: String = "취소",
        mainButtonColor: Color = .mainGreen,
        mainButtonAction: (() -> Void)? = nil,
        subButtonAction: (() -> Void)? = nil,
        isSingleButtonAlert: Bool = false
    ) {
        DispatchQueue.main.async {
            self.ruAlert = RUAlert(
                imageUrl: imageUrl,
                title: title,
                subTitle: subTitle,
                mainButtonText: mainButtonText,
                subButtonText: subButtonText,
                mainButtonColor: mainButtonColor,
                mainButtonAction: mainButtonAction ?? self.dismiss,
                subButtonAction: subButtonAction ?? self.dismiss,
                isSingleButtonAlert: isSingleButtonAlert
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
    
    func showBadgeAlert(newBadges: [Badge], navigateMyBadge: @escaping () -> Void ) {
        if newBadges.count == 0 { return }
        self.showAlert(
            imageUrl: newBadges[0].imageUrl,
            title: "'\(newBadges[0].name)'\n\(newBadges.count > 1 ? "외 \(newBadges.count - 1)개의 " : "")뱃지를 획득했어요!",
            mainButtonText: "뱃지 보러가기",
            subButtonText: "닫기",
            mainButtonAction: {
                self.dismiss()
                navigateMyBadge()
            }
        )
    }
}
