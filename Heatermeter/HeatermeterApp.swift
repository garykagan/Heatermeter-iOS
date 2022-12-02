//
//  HeatermeterApp.swift
//  Heatermeter
//
//  Created by Gary Kagan on 11/26/22.
//

import SwiftUI

@main
struct HeatermeterApp: App {
    let discovery: DeviceDiscoveryViewModel
    init() {
        self.discovery = DeviceDiscoveryViewModel()
        self.discovery.start()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
