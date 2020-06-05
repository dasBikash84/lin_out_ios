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
    
    private func getTestApiPath() -> String{
        return "\(baseApiAddress)\(testEndPoint)"
    }
    
    private func getLoginPath() -> String{
        return "\(baseApiAddress)\(loginPath)"
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
            request.httpMethod = "GET"
            request.setAuthorizationHeader(username: userName, password: password)
            
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
            print("Task fired")
        }
    }
    
}

extension URLResponse{
    func getStatusCode() -> Int{
        return (self as! HTTPURLResponse).statusCode
    }
    
    func isSuccess() -> Bool {
        return getStatusCode() == 200
    }
}

extension URLRequest {
    mutating func setAuthorizationHeader(username: String, password: String) {
        guard let data = "\(username):\(password)".data(using: String.Encoding.utf8) else { return }
        self.setValue("Basic \(data.base64EncodedString())", forHTTPHeaderField: "Authorization")
    }
}
