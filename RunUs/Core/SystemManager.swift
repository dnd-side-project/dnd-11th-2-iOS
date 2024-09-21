//
//  SystemManager.swift
//  RunUs
//
//  Created by seungyooooong on 9/7/24.
//

import UIKit
import Foundation

class SystemManager {
    static let shared = SystemManager()
    static let storeID = 6689522964
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let openAppStoreURLString = "itms-apps://itunes.apple.com/app/apple-store/\(SystemManager.storeID)"
    
    private init() { }
    
    func getServerVersion(version: String) async throws -> Bool {
        let result: VersionResponseModel = try await ServerNetwork.shared.request(.getServerVersion(version: version))
        return result.updateRequired
    }
    
    func terminateApp() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    func openAppStore() {
        guard let url = URL(string: SystemManager.openAppStoreURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func openAppSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url)
            }
        }
    }
}
