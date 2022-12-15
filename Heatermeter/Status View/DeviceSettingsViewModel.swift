//
//  DeviceSettingsViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/14/22.
//

import Foundation

class DeviceSettingsViewModel: ObservableObject {
    @Published var status: CurrentStatus
    @Published var setPoint: Int
    @Published var saving: Bool = false
    let service: HeaterMeterService
    
    init(status: CurrentStatus, service: HeaterMeterService) {
        self.status = status
        self.service = service
        self.setPoint = status.setPoint
    }
    
    func saveButtonTapped() {
        saving = true
        var config = ConfigRequestModel()
        
        setSetPoint(config: &config)
        
        let finalConfig = config
        Task {
            await service.set(config: finalConfig)
            await MainActor.run {
                saving = false
            }
        }
    }
    
    func setSetPoint(config: inout ConfigRequestModel) {
        config.setPoint = setPoint
    }
}
