//
//  DNSServiceResolver.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/2/22.
//

import Foundation
import dnssd
import Combine

class DNSServiceResolver {
    public let devicePublisher = PassthroughSubject<Device, Never>()
    private var serviceRef: DNSServiceRef? = nil
    
    func resolve(service: DNSService) {
        if serviceRef == nil {
            print("attempting to resolve", service)
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
            contextContainer.devicePublisher.send(device)
        }
    }
    
    private func createDevice(fullName: String, host: String, port: UInt16) -> Device {
        return Device(name: fullName,
                      host: host,
                      port: port)
    }
    
    func stop() {
        if self.serviceRef != nil {
            DNSServiceRefDeallocate(self.serviceRef)
        }
    }
}
