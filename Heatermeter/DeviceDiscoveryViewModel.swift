//
//  DeviceDiscoveryViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 11/30/22.
//

import Foundation
import dnssd

class DeviceDiscoveryViewModel: ObservableObject {
    @Published var devices: [Device] = []
    var browser: DNSServiceBrowser? = nil
    
    init() {
        self.browser = DNSServiceBrowser() { [weak self] device in
            self?.devices.append(device)
        }
        
        let service = DNSService(type: "_http._tcp", domain: "", name: "")
        browser?.browse(service)
    }
}
