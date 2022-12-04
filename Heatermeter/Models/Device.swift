//
//  Device.swift
//  Heatermeter
//
//  Created by Gary Kagan on 11/30/22.
//

import Foundation

struct Device: Codable, Hashable, Identifiable {
    var id = UUID()
    
    let name: String
    let host: String
    let port: UInt16
}
