//
//  WebService.swift
//  Lin Out
//
//  Created by bikash on 5/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import Foundation

struct WebService {
    
    static let INSTANCE : WebService = WebService()
    
    private init() {}
    
    private let baseApiAddress = "http://localhost:8555/"
    private let testEndPoint = "test/"
    private let loginPath = "user/login"
    private let sessionOpenPath = "work-session/open-session"
    private let sessionClosePath = "work-session/close-session"
    
    private func getTestApiPath() -> String{
        return "\(baseApiAddress)\(testEndPoint)"
    }
    
    private func getLoginPath() -> String{
        return "\(baseApiAddress)\(loginPath)"
    }
    
    private func getSessionOpenPath() -> String {
        return "\(baseApiAddress)\(sessionOpenPath)"
    }
    
    private func getSessionClosePath() -> String {
        return "\(baseApiAddress)\(sessionClosePath)"
    }
    
    func testApi() {
        if let url = URL(string: getTestApiPath()){
            print(url)
            let session = URLSession(configuration: .default)
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = session.dataTask(with: request) {
                                (data : Data?, response : URLResponse?, error : Error?) in
                                print("Callback called")
                                if error != nil {
                                    print(error ?? "No error")
                                    return
                                }
                                if let responseData = data{
                                    print(String(data:responseData,encoding: .utf8) ?? "No data")
                                }
                            }
            task.resume()
            print("Task fired")
        }
    }
    
    func login(userName:String,password:String,
               doOnSuccess: @escaping  ()->Void, doOnFailure: @escaping  ()->Void){
        
        if let url = URL(string: getLoginPath()){
            print(url)
            print("User \(userName)")
            print("Password: \(password)")
            let session = URLSession(configuration: .default)
            
            var request = URLRequest(url: url)
            request.setGetMethod()
            request.setBasicAuthorizationHeader(username: userName, password: password)
            
            let task = session.dataTask(with: request) {
                                (data : Data?, response : URLResponse?, error : Error?) in
                                print("Callback called")
                if(response?.isSuccess() ?? false){
                    if let responseData = data {
                        print(String(data:responseData,encoding: .utf8) ?? "No data")
                    }
                    doOnSuccess()
                }else{
                    doOnFailure()
                }
            }
            task.resume()
            print("login Task fired")
        }
    }
    
    func openSession(with sessionOpenRequest:SessionOpenRequest,
                  onSuccess doOnSuccess: @escaping  (Date)->Void,
                  onFailure doOnFailure: @escaping  ()->Void){
        
        if let url = URL(string: getSessionOpenPath()){
            print(url)
            
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            
            request.setPostMethod()
            request.setBasicAuthorizationHeader()
            request.addJsonContentHeader()
            request.httpBody = sessionOpenRequest.jsonData
            
            let task = session.dataTask(with: request) {
                                (data : Data?, response : URLResponse?, error : Error?) in
                                print("Callback called")
                if(response?.isSuccess() ?? false){
                    print(String(data:data!,encoding: .utf8) ?? "No data")
                    doOnSuccess(SessionOpenRequestResponse.fromJsonData(data: data!)!.created)
                }else{
                    doOnFailure()
                }
            }
            task.resume()
            print("openSession Task fired")
        }
    }
    
    func closeSession(with sessionCloseRequest:SessionCloseRequest,
                  onSuccess doOnSuccess: @escaping  ()->Void,
                  onFailure doOnFailure: @escaping  ()->Void){
        
        if let url = URL(string: getSessionClosePath()){
            print(url)
            
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            
            request.setPostMethod()
            request.setBasicAuthorizationHeader()
            request.addJsonContentHeader()
            request.httpBody = sessionCloseRequest.jsonData
            
            let task = session.dataTask(with: request) {
                                (data : Data?, response : URLResponse?, error : Error?) in
                                print("Callback called")
                if(response?.isSuccess() ?? false){
                    print(String(data:data!,encoding: .utf8) ?? "No data")
                    doOnSuccess()
                }else{
                    doOnFailure()
                }
            }
            task.resume()
            print("closeSession Task fired")
        }
    }
    
}

extension URLRequest {
    
    mutating func setBasicAuthorizationHeader() {
        setBasicAuthorizationHeader(
            username: LocalPersistenceService.INSTANCE.getLoggedInUserName()!,
            password: LocalPersistenceService.INSTANCE.getLoggedInUserPassword()!
        )
    }
}
