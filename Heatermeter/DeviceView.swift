//
//  DeviceView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/4/22.
//

import Foundation
import SwiftUI

struct DeviceView<ViewModel: DeviceViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        if viewModel.status != CurrentStatus.none {
            DeviceStatusView(viewModel: viewModel)
                .navigationTitle(Text(viewModel.device.host))
        } else {
            Text("Loading")
                .navigationTitle(Text(viewModel.device.host))
        }
    }
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceView(viewModel: DeviceViewModelImpl(device: Device(name: "heatermeter.local", host: "heatermeter.local", port: 123)))
    }
}
