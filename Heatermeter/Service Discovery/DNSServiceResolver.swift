//
//  DNSServiceResolver.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/2/22.
//

import Foundation
import dnssd

class DNSServiceResolver {
    private var serviceRef: DNSServiceRef? = nil
    let foundDeviceCallback: (Device) -> Void
    
    init(foundDeviceCallback: @escaping (Device) -> Void) {
        self.foundDeviceCallback = foundDeviceCallback
    }
    
    func resolve(service: DNSService) {
        if serviceRef == nil {
            let context = Unmanaged.passUnretained(self).toOpaque()
            
            var errorCode = DNSServiceResolve(&serviceRef,
                                              0,
                                              0,
                                              service.name,
                                              service.type,
                                              service.domain,
                                              resolveReplyFunction(),
                                              context)
            
            guard errorCode == kDNSServiceErr_NoError else {
                // Throw!
                return
            }
            
            errorCode = DNSServiceSetDispatchQueue(serviceRef, DispatchQueue.main)
            
            guard errorCode == kDNSServiceErr_NoError else {
                // Throw!
                return
            }
        }
    }
    
    private func resolveReplyFunction() -> DNSServiceResolveReply {
        return { serviceRef, flags, interfaceIndex, errorCode, fullName, hosttarget, port, txtLen, txtRecord, context in
            
            guard let context = context else { return }
            
            let contextContainer = Unmanaged<DNSServiceResolver>.fromOpaque(context).takeUnretainedValue()
            
            let device = contextContainer.createDevice(fullName: fullName.unwrap(),
                                                                    host: hosttarget.unwrap(),
                                                                    port: port)
            print("===GK===", "Device", device)
            contextContainer.foundDeviceCallback(device)
        }
    }
    
    private func createDevice(fullName: String, host: String, port: UInt16) -> Device {
        return Device(name: fullName,
                      host: host,
                      port: port)
    }
}
