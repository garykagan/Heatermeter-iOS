//
//  ProbeViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/5/22.
//

import Foundation
import SwiftUI

class ProbeViewModel: ObservableObject {
    let thermometer: Temp
    
    init(thermometer: Temp) {
        self.thermometer = thermometer
    }
}
