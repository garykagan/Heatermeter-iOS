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
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Set Point")
                                .font(.body)
                                .foregroundColor(.white)
                            Text(viewModel.status.setPoint.degrees())
                                .font(.title2)
                                .foregroundColor(.yellow)
                                .bold()
                                .modifier(DisplayReadout())
                        }
                        .padding()
                        Spacer()
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Fan")
                                    Text(viewModel.status.fan.outputPercentage.percent())
                                }
                                .foregroundColor(.indigo)
                                VStack(alignment: .trailing) {
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
                            .modifier(DisplayReadout())
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .background(Color(uiColor: .lightGray))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.indigo, lineWidth: 3)
                    )
                    .cornerRadius(10)
                    .padding([.leading, .trailing])
                    .onTapGesture {
                        viewModel.deviceSettingsTapped()
                    }
                    .sheet(isPresented: $viewModel.deviceSettingsPresented) {
                        DeviceSettingsView(viewModel: DeviceSettingsViewModel(status: viewModel.status, service: viewModel.service))
                    }
                    
                    ForEach(Array(viewModel.status.temps.enumerated()), id: \.offset) { index, temp in
                        if let probe = ProbeIndex(rawValue: index) {
                            let probeViewModel = viewModel.probeViewModel(probe: probe)
                            ProbeView(viewModel: probeViewModel)
                                .padding([.leading, .trailing])
                        }
                    }
                    
                    Text("Updated \(viewModel.updatedDate.formatted(.dateTime.day().month().year().hour().minute().second()))")
                        .font(.footnote)
                        .padding(.bottom)
                }
            }
        }
        .navigationBarItems(trailing: NavigationLink(value: NavigationDestination.graph(viewModel.device), label: {
            Image(systemName: "waveform.path.ecg")
        }))
        .navigationTitle(viewModel.device.host)
            
    }
}
