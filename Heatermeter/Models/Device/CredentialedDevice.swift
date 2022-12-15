//
//  CredentialedDevice.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/12/22.
//

import Foundation

struct CredentialedDevice: Device {
    var id: String {
        return host + password
    }
    
    let host: String
    let username: String
    let password: String
}
