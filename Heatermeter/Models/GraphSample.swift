//
//  GraphSample.swift
//  Heatermeter
//
//  Created by Gary Kagan on 11/29/22.
//

import Foundation
import CodableCSV

struct GraphSample: Codable {
    enum CodingKeys: Int, CodingKey {
        case timestamp
        case setPoint
        case probe0
        case probe1
        case probe2
        case probe3
        case lidPid
    }
    
    let timestamp: Int
    let setPoint: Double
    let probe0Temp: Double?
    let probe1Temp: Double?
    let probe2Temp: Double?
    let probe3Temp: Double?
    let lidOpenTimer: Int?
    let pidOutputPercent: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.timestamp = try container.decode(Int.self, forKey: .timestamp)
        self.setPoint = try container.decode(Double.self, forKey: .setPoint)
        self.probe0Temp = try? container.decode(Double.self, forKey: .probe0)
        self.probe1Temp = try? container.decode(Double.self, forKey: .probe1)
        self.probe2Temp = try? container.decode(Double.self, forKey: .probe2)
        self.probe3Temp = try?
        container.decode(Double.self, forKey: .probe3)
        
        if let lidPid = try? container.decode(Int.self, forKey: .lidPid) {
            if lidPid >= 0 {
                self.pidOutputPercent = lidPid
                self.lidOpenTimer = nil
            } else {
                self.lidOpenTimer = -1 * lidPid
                self.pidOutputPercent = nil
            }
        } else {
            self.lidOpenTimer = nil
            self.pidOutputPercent = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timestamp, forKey: .timestamp)
        try container.encode(self.setPoint, forKey: .setPoint)
        try container.encode(self.probe0Temp, forKey: .probe0)
        try container.encode(self.probe1Temp, forKey: .probe1)
        try container.encode(self.probe2Temp, forKey: .probe2)
        try container.encode(self.probe3Temp, forKey: .probe3)
        
        if let pidOutputPercent = pidOutputPercent {
            try container.encode(pidOutputPercent, forKey: .lidPid)
        } else if let lidOpenTimer = lidOpenTimer {
            try container.encode(lidOpenTimer, forKey: .lidPid)
        }
    }
}
