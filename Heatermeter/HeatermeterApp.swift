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
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DeviceDiscoveryView(viewModel: DeviceDiscoveryViewModel())
            }
        }
    }
    
    init() {
    }
}
