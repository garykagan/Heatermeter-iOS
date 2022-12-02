//
//  DeviceDiscoveryViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 11/30/22.
//

import Foundation
import dnssd

class DeviceDiscoveryViewModel {
    private var serviceRef: DNSServiceRef? = nil
    
    @Published var devices: [Device] = []

    func start() {
        guard serviceRef == nil else {
            return
        }
        
        let context = Unmanaged.passUnretained(self).toOpaque()
        
        var errorCode = DNSServiceBrowse(&serviceRef,
                                         0,
                                         0,
                                         "_http._tcp",
                                         "",
                                         browseReplyFunction(),
                                         context)
        
        if errorCode == kDNSServiceErr_NoError {
            errorCode = DNSServiceSetDispatchQueue(serviceRef,
                                                   DispatchQueue.global())
        }
        
        if errorCode == kDNSServiceErr_NoError {
            // Report start success
        } else {
            // Report start failure
        }
    }
    
    func browseReply(flags: DNSServiceFlags, domain: String, type: String, name: String) {
        // Do something with the browse reply
    }
    
    private func browseReplyFunction() -> DNSServiceBrowseReply {
        return { serviceRef, flags, interfaceIndex, errorCode, serviceName, regType, replyDomain, context in
            
            guard let context = context else { return }
            
            let capturedSelf = Unmanaged<DeviceDiscoveryViewModel>.fromOpaque(context).takeUnretainedValue()
            
            capturedSelf.browseReply(flags: flags,
                                     domain: replyDomain.unwrap(),
                                     type: regType.unwrap(),
                                     name: serviceName.unwrap())
        }
    }
}

extension Optional where Wrapped == UnsafePointer<CChar> {
    func unwrap(fallback: String = "") -> String {
        let value: String
        if let cValue = self {
            value = String(cString: cValue)
        } else {
            value = fallback
        }
        
        return value
    }
}
