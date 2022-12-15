//
//  Temp.swift
//  Heatermeter
//
//  Created by Gary Kagan on 11/29/22.
//

import Foundation

struct Temp: Codable, Identifiable, Equatable {
    var id = UUID()
    
    struct RF: Codable, Equatable {
        enum CodingKeys: String, CodingKey {
            case signal = "s"
            case lowBattery = "b"
        }
        
        let signal: Int
        let lowBattery: Bool
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.signal = try container.decode(Int.self, forKey: .signal)
            let rawBattery = try container.decode(Int.self, forKey: .lowBattery)
            
            self.lowBattery = rawBattery == 0 ? false : true
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "n"
        case currentTemp = "c"
        case degreesPerHour = "dph"
        case alarm = "a"
        case rf
    }
    
    let name: String
    let currentTemp: Double?
    let degreesPerHour: Double?
    let alarm: Alarm
    let rf: RF?
    
    var activeAlarm: Alarm.RingType? {
        guard let currentTemp else {
            return nil
        }
        
        if alarm.high > -1 && Double(alarm.high) < currentTemp {
            return .high
        } else if alarm.low > -1 && Double(alarm.low) > currentTemp {
            return .low
        }
        
        return nil
    }
    
    init(name: String, currentTemp: Double? = nil, degreesPerHour: Double? = nil, alarm: Alarm, rf: RF? = nil) {
        self.name = name
        self.currentTemp = currentTemp
        self.degreesPerHour = degreesPerHour
        self.alarm = alarm
        self.rf = rf
    }
}
