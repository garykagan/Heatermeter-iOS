//
//  DNSServiceBrowser.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/3/22.
//

import Foundation
import dnssd

class DNSServiceBrowser {
    var serviceRef: DNSServiceRef? = nil
    let resolver: DNSServiceResolver
    
    init(foundDeviceCallback: @escaping (Device) -> Void) {
        self.resolver = DNSServiceResolver(foundDeviceCallback: foundDeviceCallback)
    }
    
    private func browseReplyFunction() -> DNSServiceBrowseReply {
        return { serviceRef, flags, interfaceIndex, errorCode, serviceName, regType, replyDomain, context in
            
            guard let context = context else { return }
            
            let contextContainer = Unmanaged<DNSServiceBrowser>
                .fromOpaque(context)
                .takeUnretainedValue()
            
            contextContainer.browseReply(flags: flags,
                                                      domain: replyDomain.unwrap(),
                                                      type: regType.unwrap(),
                                                      name: serviceName.unwrap())
        }
    }
    
    func browseReply(flags: DNSServiceFlags, domain: String, type: String, name: String) {
        // Do something with the browse reply
        let service = DNSService(type: type,
                                 domain: domain,
                                 name: name)
        print("===GK===", "found service", service)
        resolver.resolve(service: service)
    }
    
    func browse(_ service: DNSService) {
        guard serviceRef == nil else {
            return
        }
        
        let context = Unmanaged.passUnretained(self).toOpaque()
        
        var errorCode = DNSServiceBrowse(&serviceRef,
                                         0,
                                         0,
                                         service.type,
                                         service.domain,
                                         browseReplyFunction(),
                                         context)
        
        if errorCode == kDNSServiceErr_NoError {
            errorCode = DNSServiceSetDispatchQueue(serviceRef,
                                                   DispatchQueue.main)
        }
        
        if errorCode == kDNSServiceErr_NoError {
            // Report start success
        } else {
            // Report start failure
        }
    }
}
