//
//  DeviceDiscoveryViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 11/30/22.
//

import Foundation
import dnssd
import Combine
import SwiftUI

class DeviceDiscoveryViewModel: ObservableObject {
    @Binding var presented: Bool
    @Binding var selectedDevice: DiscoveredDevice?
    @Published var devices: [DiscoveredDevice] = []
    var serviceDiscovery: DNSServiceDiscovery? = nil
    var devicesCancellable: Cancellable? = nil
    let localNetworkAuthorization: LocalNetworkAuthorization = LocalNetworkAuthorization()
    
    init(presented: Binding<Bool>, selectedDevice : Binding<DiscoveredDevice?>) {
        self._presented = presented
        self._selectedDevice = selectedDevice
        
        localNetworkAuthorization.requestAuthorization { authed in
            let service = DNSService(type: "_http._tcp")
            self.serviceDiscovery = DNSServiceDiscovery(service: service)
            self.configure()
            self.start()
        }
    }
    
    func dismiss() {
        serviceDiscovery?.stop()
        presented = false
    }
    
    private func configure() {
        serviceDiscovery?.filter = { service in
            return service.name.hasPrefix("HeaterMeter on")
        }
        
        devicesCancellable = serviceDiscovery?
            .$discoveredDevices
            .map { devices in
                devices.sorted()
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.devices, on: self)
    }
    
    func start() {
        serviceDiscovery?.start()
    }
    
    deinit {
        serviceDiscovery?.stop()
    }
}
