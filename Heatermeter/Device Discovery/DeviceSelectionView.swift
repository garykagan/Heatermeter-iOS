//
//  DeviceSelectionView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/9/22.
//

import Foundation
import SwiftUI

struct DeviceSelectionView: View {
    @ObservedObject var viewModel: DeviceSelectionViewModel
    
    var body: some View {
        NavigationStack() {
            Button("Add Device") {
                viewModel.addDeviceTapped()
            }
            List() {
                ForEach(viewModel.recentDevices) { device in
                    NavigationLink(device.host,
                                   value: NavigationDestination.status(device))
                }
                .onDelete { indexSet in
                    viewModel.deleteRecent(indexSet: indexSet)
                }
            }
            .navigationTitle("Devices")
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .status(let device):
                    DeviceView(viewModel: DeviceViewModelImpl(device: device))
                case .graph(let device):
                    GraphView(viewModel: GraphViewModelImpl(device: device))
                }
            }
            .navigationBarItems(trailing: Button(action: {
                viewModel.discoverDevicesTapped()
            }, label: {
                Text("Discover")
            })
                .popover(isPresented: $viewModel.deviceDiscoveryPresented, content: {
                    DeviceDiscoveryView(viewModel: DeviceDiscoveryViewModel(presented: $viewModel.deviceDiscoveryPresented, selectedDevice: $viewModel.foundDevice))
                })
            )
            .sheet(isPresented: $viewModel.addDeviceSheetPresented) {
                AddDeviceView(viewModel: AddDeviceViewModel(discoveredDevice: viewModel.foundDevice,
                                                            presented: $viewModel.addDeviceSheetPresented,
                                                            createdDevice: $viewModel.createdDevice))
            }
        }
    }
}
