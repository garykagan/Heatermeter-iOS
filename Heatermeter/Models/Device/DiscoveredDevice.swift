//
//  DiscoveredDevice.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/12/22.
//

import Foundation

struct DiscoveredDevice: Device, Comparable {
    static func < (lhs: DiscoveredDevice, rhs: DiscoveredDevice) -> Bool {
        lhs.id < rhs.id
    }
    
    var id: String {
       return name + host + "\(port)"
    }
    
    let name: String
    let host: String
    let port: UInt16
}
