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
    var probe0Name: String?
    var probe1Name: String?
    var probe2Name: String?
    var probe3Name: String?
    var setPoint: Int?
    var alarms: AlarmSetting?
    
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
    var probe0: AlarmPair
    var probe1: AlarmPair
    var probe2: AlarmPair
    var probe3: AlarmPair
    
    var value: String {
        return [probe0, probe1, probe2, probe3]
            .map({ $0.value })
            .joined(separator: ",")
    }
    
    init(probe0: AlarmPair, probe1: AlarmPair, probe2: AlarmPair, probe3: AlarmPair) {
        self.probe0 = probe0
        self.probe1 = probe1
        self.probe2 = probe2
        self.probe3 = probe3
    }
    
    init(temps: [Temp]) {
        self.init(probe0: AlarmPair(low: temps[safe: 0]?.alarm.low,
                                                           high: temps[safe: 0]?.alarm.high),
                                         probe1: AlarmPair(low: temps[safe: 1]?.alarm.low,
                                                           high: temps[safe: 1]?.alarm.high),
                                         probe2: AlarmPair(low: temps[safe: 2]?.alarm.low,
                                                           high: temps[safe: 2]?.alarm.high),
                                         probe3: AlarmPair(low: temps[safe: 3]?.alarm.low,
                                                           high: temps[safe: 3]?.alarm.high))
    }
}

struct AlarmPair {
    let low: Int?
    let high: Int?
    
    var value: String {
        return "\(low ?? -1),\(high ?? -1)"
    }
}
