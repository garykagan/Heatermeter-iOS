//
//  AddDeviceViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/9/22.
//

import Foundation
import SwiftUI
import Combine

enum AuthType {
    case apiKey
    case password
}

class AddDeviceViewModel: ObservableObject {
    @Binding var presented: Bool
    @Binding var createdDevice: AuthedDevice?
    @Published var host: String = ""
    @Published var apiKey: String = ""
    @Published var username: String = "root"
    @Published var password: String = ""
    @Published var authType: AuthType = .password
    @Published var verifyingDevice: Bool = false
    @Published var connectionError: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var validDeviceConfiguration: Bool = false
    
    init(discoveredDevice: DiscoveredDevice?, presented: Binding<Bool>, createdDevice: Binding<AuthedDevice?>) {
        self._presented = presented
        self._createdDevice = createdDevice
        if let discoveredDevice {
            self.host = discoveredDevice.host
        }
        
        registerFieldUpdate(publisher: self._host.projectedValue)
        registerFieldUpdate(publisher: self._apiKey.projectedValue)
        registerFieldUpdate(publisher: self._password.projectedValue)
        registerFieldUpdate(publisher: self._username.projectedValue)
    }
    
    func createDevice() {
        connectionError = false
        verifyingDevice = true
        Task {
            let device: AuthedDevice?
            switch authType {
            case .apiKey:
                device = await validateAndCreateAPIKeyDevice()
            case .password:
                device = await validateAndCreatePasswordDevice()
            }
            
            await MainActor.run {
                verifyingDevice = false
                
                if let device {
                    createdDevice = device
                    dismiss()
                } else {
                    connectionError = true
                }
            }
        }
    }
    
    private func validateAndCreateAPIKeyDevice() async -> AuthedDevice? {
        return await validateAndCreateAPIKeyDevice(host: host,
                                                   apiKey: apiKey)
    }
    
    private func validateAndCreateAPIKeyDevice(host: String, apiKey: String) async -> AuthedDevice? {
        let candidateDevice = AuthedDevice(host: host,
                                           apiKey: apiKey)
        guard let result: HeaterMeterService.AuthValidationResult = try? await HeaterMeterService.validate(device: candidateDevice) else {
            return nil
        }
        
        if case .ok(_) = result {
            return candidateDevice
        }
        
        return nil
    }
    
    private func validateAndCreatePasswordDevice() async -> AuthedDevice? {
        let credentialedDevice = CredentialedDevice(host: host,
                                                    username: username,
                                                    password: password)
        guard let apiKey = try? await HeaterMeterService.getAPIKey(device: credentialedDevice) else {
            return nil
        }
        
        return await validateAndCreateAPIKeyDevice(host: host, apiKey: apiKey)
    }
    
    func dismiss() {
        presented = false
    }
    
    private func registerFieldUpdate<T>(publisher: Published<T>.Publisher) {
        publisher.sink { [weak self] _ in
            guard let self else {
                return
            }
            
            self.fieldUpdate()
        }
        .store(in: &cancellables)
    }
    
    private func fieldUpdate() {
        switch authType {
        case .apiKey:
            validDeviceConfiguration = validateHost() && validateAPIKey()
        case .password:
            validDeviceConfiguration = validateHost() && validatePassword() && validateUsername()
        }
    }
    
    private func validateHost() -> Bool {
        // Host isn't always ip, so we can only check the count and validate at request time
        return host.count > 0
    }
    
    private func validateAPIKey() -> Bool {
        return apiKey.count > 0
    }
    
    private func validateUsername() -> Bool {
        return username.count > 0
    }
    
    private func validatePassword() -> Bool {
       return true
    }
}
