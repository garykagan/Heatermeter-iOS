//
//  DeviceDiscoveryViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 11/30/22.
//

import Foundation
import dnssd
import Combine

class DeviceDiscoveryViewModel: ObservableObject {
    @Published var devices: [Device] = []
    var serviceDiscovery: DNSServiceDiscovery? = nil
    var devicesCancellable: Cancellable? = nil
    let localNetworkAuthorization: LocalNetworkAuthorization = LocalNetworkAuthorization()
    
    init() {
        localNetworkAuthorization.requestAuthorization { authed in
            let service = DNSService(type: "_http._tcp")
            self.serviceDiscovery = DNSServiceDiscovery(service: service)
            self.configure()
            self.start()
        }
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
}
