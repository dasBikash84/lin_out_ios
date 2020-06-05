//
//  SignOutRequest.swift
//  Lin Out
//
//  Created by bikash on 5/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import Foundation

struct SessionCloseRequest : Codable {
    let comments: String
    let lat: Double
    let lan: Double
    let address: String
    let postCode: String
    let macAddress: String
}
