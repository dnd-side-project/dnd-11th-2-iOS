//
//  AlertEnvironment.swift
//  RunUs
//
//  Created by seungyooooong on 9/5/24.
//

import Foundation
import SwiftUI

class AlertEnvironment: ObservableObject {
    @Published var isShowAlert: Bool = false
    @Published var ruAlert: RUAlert = RUAlert(title: "", subTitle: "", mainButtonText: "확인", subButtonText: "취소", mainButtonColor: .mainGreen, mainButtonAction: {}, subButtonAction: {})
    
    func showAlert(
        title: String,
        subTitle: String = "",
        mainButtonText: String = "확인",
        subButtonText: String = "취소",
        mainButtonColor: Color = .mainGreen,
        mainButtonAction: (() -> Void)? = nil,
        subButtonAction: (() -> Void)? = nil
    ) {
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
    
    func dismiss() {
        self.isShowAlert = false
    }
}
