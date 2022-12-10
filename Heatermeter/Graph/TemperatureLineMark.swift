//
//  TemperatureLineMark.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/6/22.
//

import Foundation
import SwiftUI
import Charts

struct TemperatureLineMark: ChartContent {
    let sample: GraphSample
    let keyPath: KeyPath<GraphSample, Double?>
    let seriesName: String
    
    var body: some ChartContent {
        LineMark(x: .value("Time", sample.timestamp),
                 y: .value("Temperature", sample[keyPath: keyPath] ?? 0), series: .value("Probe", seriesName))
        .foregroundStyle(by: .value("Probe", seriesName))
        .interpolationMethod(.catmullRom)
    }
}
