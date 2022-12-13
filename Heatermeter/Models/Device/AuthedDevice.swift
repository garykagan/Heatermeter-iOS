//
//  AuthedDevice.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/9/22.
//

import Foundation

protocol Device {
    var host: String { get }
}

struct AuthedDevice: Device, Codable, Identifiable, Hashable {
    var id: String {
        return host + apiKey
    }
    
    let host: String
    let apiKey: String
}
