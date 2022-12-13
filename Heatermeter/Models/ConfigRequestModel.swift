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
    
    init(probe0Name: String? = nil, probe1Name: String? = nil, probe2Name: String? = nil, probe3Name: String? = nil, setPoint: Int? = nil, alarms: AlarmSetting? = nil) {
        self.probe0Name = probe0Name
        self.probe1Name = probe1Name
        self.probe2Name = probe2Name
        self.probe3Name = probe3Name
        self.setPoint = setPoint
        self.alarms = alarms
    }
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
