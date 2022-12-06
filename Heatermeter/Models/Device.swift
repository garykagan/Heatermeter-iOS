//
//  Device.swift
//  Heatermeter
//
//  Created by Gary Kagan on 11/30/22.
//

import Foundation

struct Device: Codable, Hashable, Identifiable, Comparable {
    static func < (lhs: Device, rhs: Device) -> Bool {
        lhs.id < rhs.id
    }
    
    var id: String {
       return name + host + "\(port)"
    }
    
    let name: String
    let host: String
    let port: UInt16
}
