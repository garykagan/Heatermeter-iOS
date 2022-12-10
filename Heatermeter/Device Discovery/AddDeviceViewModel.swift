//
//  AddDeviceViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/9/22.
//

import Foundation
import SwiftUI
import Combine

class AddDeviceViewModel: ObservableObject {
    @Binding var presented: Bool
    @Binding var createdDevice: AuthedDevice?
    @Published var host: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var validDeviceConfiguration: Bool = false
    
    init(discoveredDevice: DiscoveredDevice?, presented: Binding<Bool>, createdDevice: Binding<AuthedDevice?>) {
        self._presented = presented
        self._createdDevice = createdDevice
        if let discoveredDevice {
            self.host = discoveredDevice.host
        }
        
        registerFieldUpdate(publisher: self._host.projectedValue)
        registerFieldUpdate(publisher: self._username.projectedValue)
        registerFieldUpdate(publisher: self._password.projectedValue)
    }
    
    func createDevice() {
        createdDevice = AuthedDevice(host: host,
                                     username: username,
                                     password: password)
        dismiss()
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
        validDeviceConfiguration = validateHost() && validateUsername() && validatePassword()
    }
    
    private func validateHost() -> Bool {
        // Host isn't always ip, so we can only check the count and validate at request time
        return host.count > 0
    }
    
    private func validateUsername() -> Bool {
        return username.count > 0
    }
    
    private func validatePassword() -> Bool {
       return true
    }
}
