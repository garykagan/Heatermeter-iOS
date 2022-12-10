//
//  HeatermeterApp.swift
//  Heatermeter
//
//  Created by Gary Kagan on 11/26/22.
//

import SwiftUI

@main
struct HeatermeterApp: App {
    let viewModel = DeviceSelectionViewModel()
    var body: some Scene {
        WindowGroup {
            DeviceSelectionView(viewModel: viewModel)
        }
    }
    
    init() {
    }
}
