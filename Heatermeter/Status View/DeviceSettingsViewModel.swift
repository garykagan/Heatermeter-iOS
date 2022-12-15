//
//  DeviceSettingsViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/14/22.
//

import Foundation
import SwiftUI

class DeviceSettingsViewModel: ObservableObject {
    @Published var status: CurrentStatus
    @Published var setPoint: Int
    @Published var saving: Bool = false
    @Binding var hideDisconnectedProbes: Bool
    @Published var hideDisconnectedProbesScratch: Bool
    let service: HeaterMeterService
    
    init(status: CurrentStatus, service: HeaterMeterService, hideDisconnectedProbes: Binding<Bool>) {
        self.status = status
        self.service = service
        self.setPoint = status.setPoint
        self.hideDisconnectedProbesScratch = hideDisconnectedProbes.wrappedValue
        self._hideDisconnectedProbes = hideDisconnectedProbes
    }
    
    func saveButtonTapped() {
        saving = true
        var config = ConfigRequestModel()
        
        setSetPoint(config: &config)
        
        let finalConfig = config
        Task {
            await service.set(config: finalConfig)
            await MainActor.run {
                self.hideDisconnectedProbes = hideDisconnectedProbesScratch
                saving = false
            }
        }
    }
    
    func setSetPoint(config: inout ConfigRequestModel) {
        config.setPoint = setPoint
    }
}
