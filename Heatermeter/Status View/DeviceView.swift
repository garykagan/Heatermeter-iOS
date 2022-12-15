//
//  DeviceStatusView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/5/22.
//

import SwiftUI

struct DeviceView<ViewModel: DeviceViewModel>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            if viewModel.status == .none {
                Text("Loading...")
            } else {
                VStack {
                    VStack {
                        HStack {
                            Text("Set Point")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text(viewModel.status.setPoint.degrees())
                                .font(.title2)
                                .foregroundColor(.yellow)
                                .bold()
                        }
                        HStack {
                            VStack {
                                Text("Fan")
                                Text(viewModel.status.fan.outputPercentage.percent())
                            }
                            .foregroundColor(.indigo)
                            VStack {
                                Text("Avg")
                                Text(
                                    viewModel.status
                                        .fan
                                        .averageOutputPercentage
                                        .percent()
                                )
                            }
                            .foregroundColor(.purple)
                        }
                        .bold()
                        .padding()
                        .frame(maxHeight: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 3)
                        )
                        .background(.white)
                    }
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .background(Color(uiColor: .lightGray))
                    .cornerRadius(10)
                    .padding([.leading, .trailing])
                    
                    ForEach(Array(viewModel.status.temps.enumerated()), id: \.offset) { index, temp in
                        if let probe = ProbeIndex(rawValue: index) {
                            let probeViewModel = viewModel.probeViewModel(probe: probe)
                            ProbeView(viewModel: probeViewModel)
                                .padding([.leading, .trailing])
                        }
                    }
                }
            }
        }
        .navigationBarItems(trailing: NavigationLink(value: NavigationDestination.graph(viewModel.device), label: {
            Image(systemName: "waveform.path.ecg")
        }))
        .navigationTitle(viewModel.device.host)
            
    }
}
