//
//  SignInRequest.swift
//  Lin Out
//
//  Created by bikash on 5/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import Foundation

struct SessionOpenRequest : Codable {
    let customerId: String
    let lat: Double
    let lan: Double
    let address: String
    let postCode: String
    let macAddress: String
}

struct SessionOpenRequestResponse : Codable {
    let id: Int
    let companyId: Int
    let active: Bool
    let created: Date
}
