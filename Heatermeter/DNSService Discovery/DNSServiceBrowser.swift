//
//  DNSServiceBrowser.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/3/22.
//

import Foundation
import dnssd
import Combine

class DNSServiceBrowser {
    let dnsServicePublisher = PassthroughSubject<DNSService, Never>()
    var serviceRef: DNSServiceRef? = nil
    
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
        print(service)
        dnsServicePublisher.send(service)
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
        } else if errorCode == kDNSServiceErr_NoAuth {
            print("Error, no auth")
        } else {
            print("Error", errorCode)
        }
        
        if errorCode == kDNSServiceErr_NoError {
            // Report start success
        } else {
            // Report start failure
            print("Error", errorCode)
        }
    }
    
    func stop() {
        if self.serviceRef != nil {
            DNSServiceRefDeallocate(self.serviceRef)
        }
    }
}
