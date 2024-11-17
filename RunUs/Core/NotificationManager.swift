//
//  NotificationManager.swift
//  RunUs
//
//  Created by seungyooooong on 11/17/24.
//

import Foundation
import UserNotifications

actor NotificationManager {
    static let shared = NotificationManager()
    private init() { }
    
    private let notificationRequestDescription: String = "\(UserDefaultManager.name ?? "런어스")님이 챌린지 또는 목표를 달성했을 때 런어스가 알려드릴게요!"
    
    func requestAuthorization() async throws -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound]
        return try await UNUserNotificationCenter.current().requestAuthorization(options: options)
    }
    
    func checkNotificationPermission(action: @escaping (Bool) async throws -> Void) async throws -> Void {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        switch settings.authorizationStatus {
        case .notDetermined:
            let result = try await self.requestAuthorization()
            try await action(result)
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
                    Task {  // TODO: 추후 안정화 필요
                        try await action(false)
                        AlertManager.shared.dismiss()
                    }
                }
            )
            return
        default:
            try await action(true)
        }
    }
    
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval = 0) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        try await UNUserNotificationCenter.current().add(request)
    }
    
    func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
