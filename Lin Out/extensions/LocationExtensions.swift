//
//  LocationExtensions.swift
//  Lin Out
//
//  Created by bikash on 5/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import Foundation
import CoreLocation


extension CLPlacemark{
    var addressString:String {
        get {
            var addressLine = ""
            var lineCount = 0
            if let line1 = name{
                addressLine.append(line1)
                lineCount += 1
            }
            if let line2 = postalCode{
                if(lineCount>0){
                    addressLine.append(", ")
                }
                addressLine.append("Postcode: \(line2)")
                lineCount += 1
            }
            if let line3 = locality{
                if(lineCount>0){
                    addressLine.append(", ")
                }
                addressLine.append(line3)
                lineCount += 1
            }
            if let line4 = administrativeArea{
                if(lineCount>0){
                    addressLine.append(", ")
                }
                addressLine.append(line4)
                lineCount += 1
            }
            if let line5 = country{
                if(lineCount>0){
                    addressLine.append(", ")
                }
                addressLine.append(line5)
                lineCount += 1
            }
            addressLine.append(".")
            return addressLine
        }
    }
}
