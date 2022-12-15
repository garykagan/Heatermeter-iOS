//
//  DeviceViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/4/22.
//

import Foundation
import SwiftUI
import Combine

class DeviceViewModel: ObservableObject {
    let device: AuthedDevice
    let service: HeaterMeterService
    @Published var status: CurrentStatus = .none
    @Published var deviceSettingsPresented: Bool = false
    
    private var probeViewModels: [ProbeIndex: ProbeViewModel] = [:]
    
    private var statusUpdateCancellable: AnyCancellable? = nil
    
    init(device: AuthedDevice) {
        self.device = device
        self.service = HeaterMeterService(device: device)
        fetchStatus()
        
        statusUpdateCancellable = $status.sink { [weak self] value in
            guard let self else { return }
            
            for (_, viewModel) in self.probeViewModels {
                viewModel.status = value
            }
        }
    }
    
    func fetchStatus() {
        Task {
            guard let status = try? await service.status() else { return }
            await MainActor.run() {
                self.status = status
            }
            try await Task.sleep(nanoseconds: NSEC_PER_SEC * UInt64(2))
            guard !Task.isCancelled else { return }
            fetchStatus()
        }
    }
    
    func probeViewModel(probe: ProbeIndex) -> ProbeViewModel {
        guard let probeViewModel = probeViewModels[probe] else {
            let viewModel = ProbeViewModel(probe: probe, status: status, service: self.service)
            probeViewModels[probe] = viewModel
            return viewModel
        }
        
        return probeViewModel
    }
    
    func deviceSettingsTapped() {
        deviceSettingsPresented = true
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
