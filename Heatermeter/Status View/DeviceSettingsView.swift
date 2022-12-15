//
//  DeviceSettingsView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/12/22.
//

import Foundation
import SwiftUI

struct DeviceSettingsView: View {
    @StateObject var viewModel: DeviceSettingsViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Set Point") {
                    HStack {
                        Spacer()
                        DigitStepper(value: $viewModel.setPoint, disableable: false)
                        Spacer()
                    }
                }
                
                Section("Notifications") {
                    
                }
            }
            .navigationTitle("Settings")
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
