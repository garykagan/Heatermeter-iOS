//
//  Alarm.swift
//  Heatermeter
//
//  Created by Gary Kagan on 11/29/22.
//

import Foundation

struct Alarm: Codable, Equatable {
    enum RingType: String, Codable {
        case high = "H"
        case low = "L"
    }
    
    enum CodingKeys: String, CodingKey {
        case low = "l"
        case high = "h"
        case ringing = "r"
    }
    
    let low: Int
    let high: Int
    let ringing: RingType?
}
