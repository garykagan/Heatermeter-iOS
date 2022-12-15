//
//  ProbeViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/5/22.
//

import Foundation
import SwiftUI

enum ProbeIndex: Int {
    case probe0
    case probe1
    case probe2
    case probe3
}

class ProbeViewModel: ObservableObject {
    @Published var thermometer: Temp
    
    let probe: ProbeIndex
    let service: HeaterMeterService
    @Published var status: CurrentStatus {
        didSet {
            thermometer = Self.thermometer(probe: probe, status: status)
            activeAlarm = thermometer.activeAlarm
            alarmTriggered = activeAlarm != nil
            self.objectWillChange.send()
        }
    }
    @Published var settingsPresented: Bool = false
    @Published var alarmTriggered: Bool
    @Published var activeAlarm: Alarm.RingType?
    
    init(probe: ProbeIndex, status: CurrentStatus, service: HeaterMeterService) {
        self.status = status
        self.probe = probe
        self.service = service
        let thermometer = Self.thermometer(probe: probe, status: status)
        self.thermometer = thermometer
        self.alarmTriggered = thermometer.activeAlarm != nil
        self.activeAlarm = thermometer.activeAlarm
    }
    
    static func thermometer(probe: ProbeIndex, status: CurrentStatus) -> Temp {
        return status.temps[safe: probe.rawValue] ?? Temp(name: "", alarm: Alarm(low: 0, high: 0, ringing: nil))
    }
    
    func probeTapped() {
        settingsPresented = true
    }
}
