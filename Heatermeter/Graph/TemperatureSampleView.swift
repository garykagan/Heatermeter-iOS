//
//  TemperatureSampleView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/6/22.
//

import Foundation
import SwiftUI
import Charts

struct TemperatureSampleView: ChartContent {
    let sample: GraphSample
    let sources: TemperatureSource
    var body: some ChartContent {
        if sources.contains(.setPoint) {
            TemperatureLineMark(sample: sample,
                                keyPath: \.setPoint,
                                seriesName: "Set Point")
        }
        
        if sources.contains(.probe0) {
            TemperatureLineMark(sample: sample,
                                keyPath: \.probe0Temp,
                                seriesName: "Probe 0")
        }
        
        if sources.contains(.probe1) {
            TemperatureLineMark(sample: sample,
                                keyPath: \.probe1Temp,
                                seriesName: "Probe 1")
        }
        
        if sources.contains(.probe2) {
            TemperatureLineMark(sample: sample,
                                keyPath: \.probe2Temp,
                                seriesName: "Probe 2")
        }
        
        if sources.contains(.probe3) {
            TemperatureLineMark(sample: sample,
                                keyPath: \.probe3Temp,
                                seriesName: "Probe 3")
        }
        
//        LineMark(x: .value("Time", sample.timestamp), y: .value("Fan Percent", pid), series: .value("Probe", "Fan (%)"))
//            .foregroundStyle(by: .value("Probe", "Fan (%)"))
//            .interpolationMethod(.catmullRom)
    }
}
