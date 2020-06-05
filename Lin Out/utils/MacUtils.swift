//
//  MacUtils.swift
//  Lin Out
//
//  Created by bikash on 5/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import Foundation

class MacUtils {
    private init(){}
    
    static var INSTANCE = MacUtils()
    
    private let MAC_USER_DETAILS_KEY = "MacUtils.MAC_USER_DETAILS_KEY"
    private let EMPTY_RESPONSE = "MAC ID not found"
        
    private var macAddress:String?{
        get {
            UserDefaults.standard.object(forKey: MAC_USER_DETAILS_KEY) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: MAC_USER_DETAILS_KEY)
        }
    }
    
    func getDeviceMac(bsd : String = "en0") -> String{
        
        if let mac = macAddress {
            return mac
        }
        
        print("Will have to calculate mac")
        
        let MAC_ADDRESS_LENGTH = 6
        let separator = ":"

        var length : size_t = 0
        var buffer : [CChar]

        let bsdIndex = Int32(if_nametoindex(bsd))
        if bsdIndex == 0 {
            print("Error: could not find index for bsd name \(bsd)")
            return EMPTY_RESPONSE
        }
        let bsdData = Data(bsd.utf8)
        var managementInfoBase = [CTL_NET, AF_ROUTE, 0, AF_LINK, NET_RT_IFLIST, bsdIndex]

        if sysctl(&managementInfoBase, 6, nil, &length, nil, 0) < 0 {
            print("Error: could not determine length of info data structure");
            return EMPTY_RESPONSE;
        }

        buffer = [CChar](unsafeUninitializedCapacity: length, initializingWith: {buffer, initializedCount in
            for x in 0..<length { buffer[x] = 0 }
            initializedCount = length
        })

        if sysctl(&managementInfoBase, 6, &buffer, &length, nil, 0) < 0 {
            print("Error: could not read info data structure");
            return EMPTY_RESPONSE;
        }

        let infoData = Data(bytes: buffer, count: length)
        let indexAfterMsghdr = MemoryLayout<if_msghdr>.stride + 1
        let rangeOfToken = infoData[indexAfterMsghdr...].range(of: bsdData)!
        let lower = rangeOfToken.upperBound
        let upper = lower + MAC_ADDRESS_LENGTH
        let macAddressData = infoData[lower..<upper]
        let addressBytes = macAddressData.map{ String(format:"%02x", $0) }
        
        self.macAddress = addressBytes.joined(separator: separator)
            
        return addressBytes.joined(separator: separator)
    }
}
