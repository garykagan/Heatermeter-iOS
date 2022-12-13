//
//  AuthedDevice.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/12/22.
//

import Foundation

struct AuthedDevice: Device, Codable, Identifiable, Hashable {
     var id: String {
         return host + apiKey
     }

     let host: String
     let apiKey: String
 }
