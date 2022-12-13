//
//  ConfigRequestModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/12/22.
//

import Foundation

enum ConfigRequestFields: String {
    case setPoint = "sp"
    case alarms = "al"
    case probe0Name = "pn0"
    case probe1Name = "pn1"
    case probe2Name = "pn2"
    case probe3Name = "pn3"
}

struct ConfigRequestModel {
    let probe0Name: String?
    let probe1Name: String?
    let probe2Name: String?
    let probe3Name: String?
    let setPoint: Int?
    let alarms: AlarmSetting?
}

struct AlarmSetting {
    let probe0: AlarmPair
    let probe1: AlarmPair
    let probe2: AlarmPair
    let probe3: AlarmPair
    
    var value: String {
        return [probe0, probe1, probe2, probe3]
            .map({ $0.value })
            .joined(separator: ",")
    }
}

struct AlarmPair {
    let low: Int?
    let high: Int?
    
    var value: String {
        return "\(low ?? -1),\(high ?? -1)"
    }
}
