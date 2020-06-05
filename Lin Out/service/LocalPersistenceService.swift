//
//  LocalPersistenceService.swift
//  Lin Out
//
//  Created by bikash on 5/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import Foundation

struct LocalPersistenceService {
    private init(){}
    
    static let INSTANCE = LocalPersistenceService()
    
    private let userDefaults = UserDefaults.standard
    
    private struct KEYS {
        static let LOG_IN_USER_NAME = "LOG_IN_USER_NAME"
        static let LOG_IN_USER_PASSWORD = "LOG_IN_USER_PASSWORD"
        static let SIGN_IN_TIME = "SIGN_IN_TIME"
    }
    
    func saveLogin(userName:String,passWord:String) {
        if userName.isEmpty || passWord.isEmpty{
            fatalError("Empty username/password")
        }
        userDefaults.set(userName, forKey: KEYS.LOG_IN_USER_NAME)
        userDefaults.set(passWord, forKey: KEYS.LOG_IN_USER_PASSWORD)
    }
    
    func checkLogin() -> Bool {
        guard let userName = userDefaults.object(forKey: KEYS.LOG_IN_USER_NAME),
            let password = userDefaults.object(forKey: KEYS.LOG_IN_USER_PASSWORD) else {
                return false
        }
        print("\(userName):\(password)")
        return true
    }
    
    func getLoggedInUserName() -> String? {
        return userDefaults.object(forKey: KEYS.LOG_IN_USER_NAME) as? String
    }
    
    func getLoggedInUserPassword() -> String? {
        return userDefaults.object(forKey: KEYS.LOG_IN_USER_PASSWORD) as? String
    }
    
    func saveSignIn(date:Date){
        userDefaults.set(date, forKey: KEYS.SIGN_IN_TIME)
    }
    
    func checkSignIn()->Bool{
        return userDefaults.object(forKey: KEYS.SIGN_IN_TIME) != nil
    }
    
    func clearSignIn(){
        userDefaults.set(nil, forKey: KEYS.SIGN_IN_TIME)
    }
    
    func clearLogin(){
        clearSignIn()
        userDefaults.set(nil, forKey: KEYS.LOG_IN_USER_NAME)
        userDefaults.set(nil, forKey: KEYS.LOG_IN_USER_PASSWORD)
    }
    
    func getSignIntime() -> Date?{
        return userDefaults.object(forKey: KEYS.SIGN_IN_TIME) as? Date
    }
}
