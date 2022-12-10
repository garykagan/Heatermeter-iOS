//
//  DeviceSelectionViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/9/22.
//

import Foundation

class DeviceSelectionViewModel: ObservableObject {
    @Published var foundDevice: DiscoveredDevice? = nil {
        didSet {
            guard foundDevice != nil else { return }
            addDeviceSheetPresented = true
        }
    }
    
    @Published var createdDevice: AuthedDevice? = nil {
        didSet {
            guard let createdDevice else { return }
            recentDevices.append(createdDevice)
            connect(device: createdDevice)
            self.createdDevice = nil
        }
    }
    @Published var deviceDiscoveryPresented: Bool = false
    @Published var addDeviceSheetPresented: Bool = false
    @Published var navigationPath: [NavigationDestination] = []
 
    @Published var recentDevices: [AuthedDevice] = [] {
        didSet {
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(recentDevices) else { return }
            UserDefaults.standard.set(data, forKey: "RecentDevices")
        }
    }
    
    init() {
        hydrateRecents()
    }
    
    func hydrateRecents() {
        let decoder = JSONDecoder()
        guard let data: Data = UserDefaults.standard.object(forKey: "RecentDevices") as? Data,
              let recentDevices = try? decoder.decode([AuthedDevice].self, from: data) else {
            return
        }
        
        self.recentDevices = recentDevices
    }
    
    func deleteRecent(indexSet: IndexSet) {
        recentDevices.remove(atOffsets: indexSet)
    }
    
    func connect(device: AuthedDevice) {
        navigationPath.append(.status(device))
    }
    
    func addDeviceTapped() {
        foundDevice = nil
        addDeviceSheetPresented = true
    }
    
    func discoverDevicesTapped() {
        deviceDiscoveryPresented = true
    }
}
