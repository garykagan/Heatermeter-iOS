//
//  DeviceDiscoveryViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 11/30/22.
//

import Foundation
import Network

class DeviceDiscoveryViewModel {
    let browser: NWBrowser
    
    @Published var devices: [Device] = []
    
    init() {
        self.browser = NWBrowser(for: .applicationService(name: "_http._tcp "), using: .tcp)
    }
    
    func start() {
        browser.browseResultsChangedHandler = { [weak self] results, changes in
            guard let self = self else { return }
            self.handleResults(results: results)
        }
        browser.start(queue: .global())
    }
    
    func handleResults(results: Set<NWBrowser.Result>) {
        var devices: [Device] = []
        for result in results {
            // Check if its a heatermeter
            // If so add it to the devices array
//            The service is advertised as an _http._tcp (Web Site) service with the name HeaterMeter BBQ Controller on %h where %h is the hostname. The txt record contains a path key which is the URI of the LinkMeter webpage. All REST API functions are under the URI /luci/lm/api
        }
        self.devices = devices
    }
}
