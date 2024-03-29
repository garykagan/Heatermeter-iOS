//
//  SetAlarmView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/10/22.
//

import Foundation
import SwiftUI

struct ProbeSettingsView: View {
    @StateObject var viewModel: ProbeSettingsViewModel
    @EnvironmentObject var theme: Theme
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Probe Name") {
                    TextField("Name", text: $viewModel.name)
                }
                
                Section("Probe Alarms") {
                    HStack {
                        Spacer()
                        DigitStepper(value: $viewModel.lowValue)
                            .foregroundColor(theme.low)
                        Spacer(minLength: 10)
                        DigitStepper(value: $viewModel.highValue)
                            .foregroundColor(theme.high)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Probe \(viewModel.probe.rawValue) Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.saveButtonTapped()
                    } label: {
                        if viewModel.saving {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                            Spacer()
                                .frame(minWidth: 5, maxWidth: 5)
                            Text("Saving")
                        } else {
                            Text("Save")
                        }
                    }
                    .disabled(viewModel.saving)
                }
            }
        }
    }
}
