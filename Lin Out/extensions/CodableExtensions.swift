//
//  CodableExtensions.swift
//  Lin Out
//
//  Created by bikash on 5/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import Foundation

extension Encodable{
    var jsonData : Data? {
        get {
            do{
                return try JSONEncoder().encode(self)
            } catch{
                print(error)
                return nil
            }
        }
    }
}

extension Decodable{
    static func fromJsonData(data:Data) -> Self?{
        do{
            let decoder =  JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Self.self, from: data)
        } catch{
            print(error)
            return nil
        }
    }
}
