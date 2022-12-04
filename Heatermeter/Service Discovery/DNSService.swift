//
//  DNSServiceDiscovery.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/2/22.
//

import Foundation
import dnssd

struct DNSService {
    let type: String
    let domain: String
    let name: String
}
