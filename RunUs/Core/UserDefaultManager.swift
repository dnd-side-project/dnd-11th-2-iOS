//
//  UserDefaultManager.swift
//  RunUs
//
//  Created by seungyooooong on 8/9/24.
//

import Foundation

class UserDefaultManager {
    @UserDefault(key: .accessToken, defaultValue: nil)
    static var accessToken: String?
}

enum UserDefaultKey: String {
    case accessToken = ""
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
            self.storage.synchronize()
        }
    }
}
