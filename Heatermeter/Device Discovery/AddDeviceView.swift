//
//  AddDeviceView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/9/22.
//

import Foundation
import SwiftUI

struct AddDeviceView: View {
    @StateObject var viewModel: AddDeviceViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Host", text: $viewModel.host)
                    TextField("Username", text: $viewModel.username)
                    TextField("Password", text: $viewModel.password)
                }
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                
                Section {
                    Button("Connect") {
                        viewModel.createDevice()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(!viewModel.validDeviceConfiguration)
                }
            }
            .navigationTitle("Add Device")
            .navigationBarItems(leading: Button("Cancel",
                                                role: .cancel, action: {
                viewModel.dismiss()
            }))
        }
    }
}
