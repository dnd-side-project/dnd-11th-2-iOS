//
//  NotificationManager.swift
//  RunUs
//
//  Created by seungyooooong on 11/17/24.
//

import Foundation
import UserNotifications

actor NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    private override init() {
        super.init()
        Task { await setupNotificationDelegate() }
    }
    
    private func setupNotificationDelegate() async {
        await MainActor.run {
            UNUserNotificationCenter.current().delegate = self
        }
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
    
    private let notificationRequestDescription: String = "\(UserDefaultManager.name ?? "런어스")님이 챌린지 또는 목표를 달성했을 때 런어스가 알려드릴게요!"
    
    func requestAuthorization() async throws {
        let options: UNAuthorizationOptions = [.alert, .sound]
        try await UNUserNotificationCenter.current().requestAuthorization(options: options)
    }
    
    func checkNotificationPermission(action: @escaping () -> Void) async throws -> Void {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        switch settings.authorizationStatus {
        case .notDetermined:
            try await self.requestAuthorization()
            await MainActor.run { action() }
        case .denied:
            AlertManager.shared.showAlert(
                title: self.notificationRequestDescription,
                mainButtonText: "설정하러 가기",
                subButtonText: "다음에 하기",
                mainButtonAction: {
                    SystemManager.shared.openAppSetting()
                    AlertManager.shared.dismiss()
                },
                subButtonAction: {
                    AlertManager.shared.dismiss()
                    action()
                }
            )
            return
        default:
            await MainActor.run { action() }
        }
    }
    
    func pushNotification(title: String, body: String = "") async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        try await UNUserNotificationCenter.current().add(request)
    }
    
    func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
