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
    var thermometer: Temp {
        status.temps[safe: probe.rawValue] ?? Temp(name: "", alarm: Alarm(low: 0, high: 0, ringing: nil))
    }
    
    let probe: ProbeIndex
    let service: HeaterMeterService
    @Published var status: CurrentStatus
    @Published var settingsPresented: Bool = false
    
    init(probe: ProbeIndex, status: CurrentStatus, service: HeaterMeterService) {
        self.status = status
        self.probe = probe
        self.service = service
    }
    
    func probeTapped() {
        settingsPresented = true
    }
}
