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
                    VStack(alignment: .leading) {
                        Text("Host")
                            .foregroundColor(.black.opacity(0.75))
                            .font(.system(size: 14))
                        TextField("Host", text: $viewModel.host, prompt: Text("x.x.x.x"))
                    }
                    switch viewModel.authType {
                    case .password:
                        VStack(alignment: .leading) {
                            Text("Username")
                                .foregroundColor(.black.opacity(0.75))
                                .font(.system(size: 14))
                            TextField("Username", text: $viewModel.username, prompt: Text("user"))
                        }
                        VStack(alignment: .leading) {
                            Text("Password")
                                .foregroundColor(.black.opacity(0.75))
                                .font(.system(size: 14))
                            SecureField("Password", text: $viewModel.password, prompt: Text("***********"))
                        }
                    case .apiKey:
                        VStack(alignment: .leading) {
                            Text("API Key")
                                .foregroundColor(.black.opacity(0.75))
                                .font(.system(size: 14))
                            TextField("API Key", text: $viewModel.apiKey, prompt: Text("xxxxxxxxxxxxxxxxxxxxxx"))
                        }
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
