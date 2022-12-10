//
//  AuthedDevice.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/9/22.
//

import Foundation

struct AuthedDevice: Codable, Identifiable, Hashable {
    var id: String {
        return host + username + password
    }
    
    let host: String
    let username: String
    let password: String
}
