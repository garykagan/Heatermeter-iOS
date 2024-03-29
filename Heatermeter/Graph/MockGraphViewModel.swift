//
//  MockGraphViewModel.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/7/22.
//

import Foundation
import CodableCSV

class MockGraphViewModel: GraphViewModel {
    func dragEnded() {}
    
    func settingsTapped() {}
    
    var comparisonRange: (Date, Date)? = nil
    
    var showingSettings: Bool = false
    
    func dragged(start: Date, end: Date) {}
    
    var temperatureSources: TemperatureSource = [.probe0, .probe2]
    
    var window: GraphWindow = .all
    
    func nearestSample(at date: Date, in samples: [GraphSample]) -> GraphSample? {
        return nil
    }
    
    func stride() -> Double {
        return 100
    }
    
    var limits: (min: Double, max: Double) = (min: 0, max: 100)
    
    var filteredSamples: [GraphSample]? {
        return samples
    }
    
    let samples: [GraphSample]?
    
    init() {
        let csv = """
1405344600,65,94.043333333333,nan,44.475555555556,82.325555555556,0
1405344780,65,93.503333333333,nan,44.792222222222,82.635555555556,0
1405344960,65,93.166388888889,nan,45.036111111111,82.865,0
1405345140,65,92.903611111111,nan,45.281111111111,83.07,0
1405345320,65,92.672777777778,nan,45.592222222222,83.1,0
1405345500,65,92.414444444444,nan,45.794444444444,83.211111111111,0
1405345680,65,92.141111111111,nan,46.016666666667,83.473333333333,0
1405345860,65,92.037777777778,nan,46.314444444444,83.727222222222,0
1405346040,65,92.362222222222,nan,46.534444444444,83.935555555556,0
1405346220,65,92.021666666667,nan,46.795,84.147777777778,0
1405346400,65,91.818888888889,nan,46.982222222222,84.41,0
1405346580,65,91.867777777778,nan,47.156666666667,84.571111111111,0
1405346760,65,91.804444444444,nan,47.404444444444,84.6,0
1405346940,65,91.769444444444,nan,47.621111111111,84.626666666667,0
1405347120,65,91.727777777778,nan,47.796666666667,84.707777777778,0
1405347300,65,91.587222222222,nan,47.982222222222,84.888888888889,0
1405347480,65,91.707777777778,nan,48.182222222222,84.751111111111,0
""".data(using: .utf8)!
        self.samples = try! CSVDecoder().decode([GraphSample].self, from: csv)
    }
}
