//
//  CurrentStatus.swift
//  Heatermeter
//
//  Created by Gary Kagan on 11/29/22.
//

import Foundation

//{
//  "time":1405429467,
//  "set":65,
//  "lid":38,
//  "fan":{"c":0,"a":13,"f":10},
//  "adc":[0,0,0,0,0,3],
//  "temps":[
//    {
//      "n":"Probe 0",
//      "c":78.6,
//      "dph":1.3,
//      "rf":{"s":1,"b":0},
//      "a":{"l":-40,"h":200,"r":null}
//    },
//    ...
//  ]
//}

//time    1405429467    Current time (hopefully in UTC) in UNIX timestamp format (example is Tue, 15 Jul 2014 13:04:27 UTC). Might be incorrect if device has no Internet access.
//set    65    PID Set Point (can be C or F but doesn't specify)
//lid    38    Lid Open countdown timer. Number of seconds remaining in lid mode or 0 if lid mode is off
//fan.c    0    Current PID output percentage
//fan.a    13    Average PID output percentage over last few minutes
//fan.f    10    Current fan output percentage (restricted by min/max fan speed)
//adc[]    0,0,0,0,0,3    ADC noise range indicator. Probe 0 is adc[5], Probe 1 is adc[4], etc. May be absent if not supported.
//temps[X].n    Probe 0    Name assigned to probe
//temps[X].c    78.6    Current probe temperature
//temps[X].dph    1.3    Degrees per hour calculated (least squares linear fit). May be null if not enough data, or missing if not supported
//temps[X].a.l    -40    Probe alarm low trigger. Negative numbers indicate alarm is disabled
//temps[X].a.h    200    Probe alarm high trigger. Negative numbers indicate alarm is disabled
//temps[X].a.r    null    Probe alarm ringing. "L" or "H" if the alarm is currently triggered or null if no alarm ringing
//temps[X].rf.s    1    Assigned RF node signal strength 0-3. The RF object is not present if the probe is not of type "RF"
//temps[X].rf.b    0    Assigned RF node battery low (0=OK, 1=Low). The RF object is not present if the probe is not of type "RF"

struct CurrentStatus: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case setPoint = "set"
        case lidOpenTimer = "lid"
        case fan
        case temps
    }
    
    let setPoint: Int
    let lidOpenTimer: Int
    let fan: Fan
    let temps: [Temp]
    
    static let none: CurrentStatus = CurrentStatus(setPoint: 0,
                                                   lidOpenTimer: 0,
                                                   fan: .none,
                                                   temps: [])
}
