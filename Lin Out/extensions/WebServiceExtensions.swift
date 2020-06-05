//
//  WebServiceExtensions.swift
//  Lin Out
//
//  Created by bikash on 5/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import Foundation

extension URLResponse{
    func getStatusCode() -> Int{
        return (self as! HTTPURLResponse).statusCode
    }
    
    func isSuccess() -> Bool {
        return getStatusCode() == 200
    }
}

extension URLRequest {
    
    mutating func setBasicAuthorizationHeader(username: String, password: String) {
        guard let data = "\(username):\(password)".data(using: String.Encoding.utf8) else { fatalError("Failed to set auth header") }
        self.setValue("Basic \(data.base64EncodedString())", forHTTPHeaderField: "Authorization")
    }
    
    mutating func addJsonContentHeader(){
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    mutating func setPostMethod(){
        self.httpMethod = "POST"
    }
    
    mutating func setGetMethod(){
        self.httpMethod = "GET"
    }
}
