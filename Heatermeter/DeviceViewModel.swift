//
//  DeviceViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/4/22.
//

import Foundation

protocol DeviceViewModel: ObservableObject {
    var device: Device { get }
    var status: CurrentStatus { get }
}

class DeviceViewModelImpl: DeviceViewModel {
    let device: Device
    let service: HeaterMeterService
    @Published var status: CurrentStatus = .none
    
    init(device: Device) {
        self.device = device
        self.service = HeaterMeterService(device: device)
        fetchStatus()
    }
    
    func fetchStatus() {
        Task {
            guard let status = try? await service.status() else { return }
            await MainActor.run() {
                self.status = status
            }
            try await Task.sleep(nanoseconds: NSEC_PER_SEC * UInt64(5))
            guard !Task.isCancelled else { return }
            fetchStatus()
        }
    }
}

class MockDeviceViewModel: DeviceViewModel {
    let device: Device
    let status: CurrentStatus
    
    init(device: Device, status: CurrentStatus) {
        self.device = device
        self.status = status
    }
}
