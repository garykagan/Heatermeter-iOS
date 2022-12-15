//
//  DeviceDiscoveryView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/3/22.
//

import Foundation
import SwiftUI
import Combine

struct DeviceDiscoveryView: View {
    @StateObject var viewModel: DeviceDiscoveryViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.devices) { device in
                    Button(device.host) {
                        viewModel.selectedDevice = device
                        viewModel.presented = false
                    }
                }
            }
            .navigationTitle("Found HeaterMeters")
            .toolbar() {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        viewModel.dismiss()
                    }
                }
            }
        }
    }
}
