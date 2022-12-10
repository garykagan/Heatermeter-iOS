//
//  DNSServiceDiscovery.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/4/22.
//

import Foundation
import Combine

class DNSServiceDiscovery: ObservableObject {
    @Published var discoveredDevices = Set<DiscoveredDevice>()
    let service: DNSService
    let browser: DNSServiceBrowser = DNSServiceBrowser()
    let resolver: DNSServiceResolver = DNSServiceResolver()
    var browseCancellable: Cancellable? = nil
    var resolveCancellable: Cancellable? = nil
    var filter: ((DNSService) -> Bool)? = nil
    
    init(service: DNSService) {
        self.service = service
        configure()
    }
    
    private func configure() {
        self.browseCancellable = browser
            .dnsServicePublisher
            .filter { [weak self] service in
                guard let self = self else { return false }
                if let filter = self.filter {
                    return filter(service)
                } else {
                    return true
                }
            }
            .sink { [weak self] service in
                guard let self = self else { return }
                self.resolver.resolve(service: service)
            }
        
        self.resolveCancellable = resolver.devicePublisher.sink(receiveValue: { [weak self] device in
            guard let self = self else { return }
            self.discoveredDevices.insert(device)
        })
    }
    
    func start() {
        browser.browse(service)
    }
    
    func stop() {
        browser.stop()
        resolver.stop()
    }
    
    deinit {
        stop()
    }
}
