//
//  Theme.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/15/22.
//

import Foundation
import SwiftUI

class Theme: ObservableObject {
    let high: Color = .orange
    let low: Color = .blue
    let setPoint: Color = .yellow
    let tileBackground: Color = Color(uiColor: .lightGray)
    let degreesPerHour: Color = .teal
    let fan: Color = .purple
    let currentTemp: Color = .gray
    
    let title: Color = .white
    
    let formTitle: Color = .black.opacity(0.75)
    let formError: Color = .red
}
