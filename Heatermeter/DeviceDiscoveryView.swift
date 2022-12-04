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
        List {
            ForEach(viewModel.devices) { device in
                Text(device.host)
            }
        }
        .padding()
    }
}