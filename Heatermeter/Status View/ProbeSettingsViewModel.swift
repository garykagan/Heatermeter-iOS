//
//  ProbeSettingsViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/13/22.
//

import Foundation

class ProbeSettingsViewModel: ObservableObject {
    let probe: ProbeIndex
    let service: HeaterMeterService
    var thermometer: Temp {
        status.temps[safe: probe.rawValue] ?? Temp(name: "", alarm: Alarm(low: 0, high: 0, ringing: nil))
    }
    
    @Published var saving: Bool = false
    @Published var name: String = ""
    @Published var lowValue: Int = 0
    @Published var highValue: Int = 0
    @Published var status: CurrentStatus
    
    init(probe: ProbeIndex, service: HeaterMeterService, status: CurrentStatus) {
        self.probe = probe
        self.service = service
        self.status = status
        
        self.lowValue = thermometer.alarm.low
        self.highValue = thermometer.alarm.high
        self.name = thermometer.name
    }
    
    func saveButtonTapped() {
        saving = true
        var config = ConfigRequestModel()
        
        setProbePreferences(on: &config)
        setAlarmPreferences(on: &config)
        
        let finalConfig = config
        Task {
            await service.set(config: finalConfig)
            await try? Task.sleep(nanoseconds: NSEC_PER_SEC * 2)
            await MainActor.run {
                saving = false
            }
        }
    }
    
    func setProbePreferences(on config: inout ConfigRequestModel) {
        
    }
    
    func setAlarmPreferences(on config: inout ConfigRequestModel) {
        
    }
}
