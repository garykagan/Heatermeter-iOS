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
    @ObservedObject var viewModel: DeviceDiscoveryViewModel
    
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
            .navigationBarItems(leading: Button("Cancel",
                                                role: .cancel, action: {
                viewModel.dismiss()
            }))
        }
    }
}
