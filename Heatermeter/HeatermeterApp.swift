//
//  HeatermeterApp.swift
//  Heatermeter
//
//  Created by Gary Kagan on 11/26/22.
//

import SwiftUI
import Combine

@main
struct HeatermeterApp: App {
    let discovery: DeviceDiscoveryViewModel
    var c: Cancellable? = nil
    init() {
        self.discovery = DeviceDiscoveryViewModel()
        self.c = self.discovery.$devices.sink(receiveValue: { devices in
            print("Got Devices", devices)
        })
    }
    var body: some Scene {
        WindowGroup {
            DeviceDiscoveryView(viewModel: self.discovery)
        }
    }
}
