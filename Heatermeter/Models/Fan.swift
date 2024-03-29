//
//  Fan.swift
//  Heatermeter
//
//  Created by Gary Kagan on 11/29/22.
//

import Foundation

struct Fan: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case pidOutputPercentage = "c"
        case averageOutputPercentage = "a"
        case outputPercentage = "f"
    }
    
    let pidOutputPercentage: Int
    let averageOutputPercentage: Int
    let outputPercentage: Int
    
    static let none: Fan = Fan(pidOutputPercentage: 0,
                               averageOutputPercentage: 0,
                               outputPercentage: 0)
}
