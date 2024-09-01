//
//  UserDefaultManager.swift
//  RunUs
//
//  Created by seungyooooong on 8/9/24.
//

import Foundation

class UserDefaultManager {
    @UserDefault(key: .isLogin, defaultValue: false) static var isLogin: Bool?
    @UserDefault(key: .name, defaultValue: nil) static var name: String?
    @UserDefault(key: .email, defaultValue: nil) static var email: String?
    @UserDefault(key: .accessToken, defaultValue: nil) static var accessToken: String?
    @UserDefault(key: .selectedTabItem, defaultValue: TabItems.home.rawValue) static var selectedTabItem: String?
}

enum UserDefaultKey: String {
    case isLogin
    case name
    case email
    case accessToken
    case selectedTabItem
}

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: UserDefaultKey
    let defaultValue: T?
    let storage: UserDefaults = UserDefaults.standard
    
    init(key: UserDefaultKey,
         defaultValue: T? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            return self.storage.object(forKey: self.key.rawValue) as? T ?? self.defaultValue
        }
        set {
            self.storage.set(newValue, forKey: self.key.rawValue)
        }
    }
}
