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
                    Picker("Auth Type", selection: $viewModel.authType) {
                        let authTypes: [AuthType] = [.password, .apiKey]
                        ForEach(authTypes, id: \.self) {
                            switch $0 {
                            case .password:
                                Text("Password")
                            case .apiKey:
                                Text("API Key")
                            }
                        }
                    }
                    .pickerStyle(.segmented)
                    .foregroundColor(.black)
                }
                
                Section {
                    TextField("Host", text: $viewModel.host)
                    switch viewModel.authType {
                    case .password:
                        TextField("Password", text: $viewModel.password)
                    case .apiKey:
                        TextField("API Key", text: $viewModel.apiKey)
                    }
                }
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                Section {
                    Button {
                        viewModel.createDevice()
                    } label: {
                        HStack {
                            if viewModel.verifyingDevice {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                            
                            VStack {
                                Text("Connect")
                                if viewModel.connectionError {
                                    Text("Failed to connect")
                                        .foregroundColor(.red)
                                }
                            }
                            
                        }
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
