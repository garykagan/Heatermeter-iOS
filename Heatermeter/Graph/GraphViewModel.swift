//
//  GraphViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/5/22.
//

import Foundation
import CodableCSV

protocol GraphViewModel: ObservableObject {
    var samples: [GraphSample]? { get }
    var window: GraphWindow { get set }
    var filteredSamples: [GraphSample]? { get }
    var limits: (min: Double, max: Double) { get }
    var temperatureSources: TemperatureSource { get set }
    
    func nearestSample(at date: Date, in samples: [GraphSample]) -> GraphSample?
    func stride() -> Double
}

enum GraphWindow: Hashable {
    case hour(Int)
    case all
}

struct TemperatureSource: OptionSet {
    let rawValue: Int

    static let setPoint    = TemperatureSource(rawValue: 1 << 0)
    static let probe0       = TemperatureSource(rawValue: 1 << 1)
    static let probe1       = TemperatureSource(rawValue: 1 << 2)
    static let probe2       = TemperatureSource(rawValue: 1 << 3)
    static let probe3       = TemperatureSource(rawValue: 1 << 4)
    
    static let all: TemperatureSource = [
        .setPoint, .probe0, .probe1, .probe2, .probe3
    ]
}

class GraphViewModelImpl: GraphViewModel {
    @Published var samples: [GraphSample]? = nil
    @Published var window: GraphWindow = .hour(1)
    @Published var limits: (min: Double, max: Double) = (min: 0, max: 0)
    @Published var temperatureSources: TemperatureSource = [.probe1, .probe2]
    var filteredSamples: [GraphSample]? {
        let filtered: [GraphSample]?
        guard case let .hour(windowHours) = window else {
            return samples
        }

        if let lastSample = samples?.last {
            let calendar = Calendar.current
            filtered = samples?.filter({ sample in
                
                let diffComponents = calendar.dateComponents([.hour], from: sample.timestamp, to: lastSample.timestamp)
                let hours = diffComponents.hour!
                return hours <= windowHours
            })
        } else {
            filtered = samples
        }
        
        return filtered
    }
    
    private let service: HeaterMeterService
    init(device: AuthedDevice) {
        self.service = HeaterMeterService(device: device)
        fetchGraph()
    }
    
    private func temperatureLimits(samples: [GraphSample]) -> (min: Double, max: Double) {
        
        return samples.reduce((min: 0, max: 0)) { partialResult, sample in
            // Get the active probe values for this sample
            let probes = Array(probes(in: sample,
                                      for: temperatureSources).values)
            
            let min = Double.minimum(probes + [partialResult.min])
            let max = Double.maximum(probes + [partialResult.max])
            return (min: min, max: max)
        }
    }
    
    func probes(in sample: GraphSample, for sources: TemperatureSource) -> [String: Double?] {
        var probes: [String: Double?] = [:]
        
        if sources.contains(.setPoint) {
            probes["Set Point"] = sample.setPoint
        }
        
        if sources.contains(.probe0) {
            probes["Probe 0"] = sample.probe0Temp
        }
        
        if sources.contains(.probe1) {
            probes["Probe 1"] = sample.probe1Temp
        }
        
        if sources.contains(.probe2) {
            probes["Probe 2"] = sample.probe2Temp
        }
        
        if sources.contains(.probe3) {
            probes["Probe 3"] = sample.probe3Temp
        }
        
        return probes
    }
    
    private func fetchGraph() {
        Task {
            guard let samples = try? await self.service.graph() else { return }
            
            let limits = temperatureLimits(samples: samples)

            await MainActor.run() {
                self.samples = samples
                self.limits = limits
            }
            
            try await Task.sleep(nanoseconds: NSEC_PER_SEC * UInt64(5))
            guard !Task.isCancelled else { return }
            fetchGraph()
        }
    }
    
    public func nearestSample(at date: Date, in samples: [GraphSample]) -> GraphSample? {
        guard samples.count > 1 else {
            return samples.first
        }
        
        let leftSplit: ArraySlice<GraphSample> = samples[0 ..< samples.count / 2]
        let rightSplit: ArraySlice<GraphSample> = samples[samples.count / 2 ..< samples.count]
        let leftSamples: [GraphSample] = Array(leftSplit)
        let rightSamples: [GraphSample] = Array(rightSplit)
        
        let left = nearestSample(at: date, in: leftSamples)
        let right = nearestSample(at: date, in: rightSamples)
        
        guard let left = left ?? leftSamples.first else {
            return right
        }
        
        guard let right = right ?? rightSamples.last else {
            return left
        }
        
        let leftDiff = (left.timestamp - date).magnitude
        let rightDiff = (right.timestamp - date).magnitude
        
        return leftDiff < rightDiff ? left : right
    }
    
    func stride() -> Double {
        let roundedYAxisMaxValue = roundUp(limits.max, to: 2)
        let roundedYAxisMinValue = roundUp(limits.min, to: 2)
        let strideValue = max(abs(roundedYAxisMaxValue), abs(roundedYAxisMinValue)) / 3.0
        print("rounded y max", roundedYAxisMaxValue)
        print("rounded y min", roundedYAxisMinValue)
        print("stride", strideValue)
        return strideValue
    }
    
    //round up to x significant digits
    func roundUp(_ num: Double, to places: Int) -> Double {
        let p = log10(abs(num))
        let f = pow(10, p.rounded(.up) - Double(places) + 1)
        let rnum = (num / f).rounded(.up) * f
        return rnum
    }
}
