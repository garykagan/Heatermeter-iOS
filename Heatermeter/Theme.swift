//
//  Theme.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/15/22.
//

import Foundation
import SwiftUI

class Theme: ObservableObject {
    let high: Color = Color("high")
    let low: Color = Color("low")
    let setPoint: Color = Color("setPoint")
    let tileBackground: Color = Color("tileBackground")
    let degreesPerHour: Color = Color("dph")
    let fan: Color = Color("fan")
    let currentTemp: Color = Color("currentTemp")
    
    let title: Color = Color("title")
    
    let formTitle: Color = Color("formTitle")
    let formError: Color = Color("formError")
    let displayBackground: Color = Color("displayBackground")
}
