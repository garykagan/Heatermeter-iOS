//
//  NumberDiffView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/6/22.
//

import Foundation
import SwiftUI

struct NumberDiffView: View {
    let title: String
    let diff: String
    
    var body: some View {
        HStack {
            Text(title)
                .frame(alignment: .leading)
                .bold()
            Text(diff)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct ProbeDiffView: View {
    let title: String
    let startSample: GraphSample
    let endSample: GraphSample
    let keyPath: KeyPath<GraphSample, Double?>
    
    var body: some View {
        NumberDiffView(title: title, diff: tempDifference())
    }
    
    func tempDifference() -> String {
        let value1: Double = startSample[keyPath: keyPath] ?? 0
        let value2: Double = endSample[keyPath: keyPath] ?? 0
        let diff = value2 - value1
        
        var sign: String = ""
        
        if diff > 0 {
            sign = "+"
        }
        
        return "\(sign)\(diff.degrees(allowNegative: true))"
    }
}

struct PidDiffView: View {
    let title: String
    let startSample: GraphSample
    let endSample: GraphSample
    let keyPath: KeyPath<GraphSample, Int?>
    
    var body: some View {
        NumberDiffView(title: title, diff: tempDifference())
    }
    
    func tempDifference() -> String {
        let value1: Int = startSample[keyPath: keyPath] ?? 0
        let value2: Int = endSample[keyPath: keyPath] ?? 0
        let diff = value2 - value1
        
        return diff.percent(allowNegative: true)
    }
}

struct Diff_Previews: PreviewProvider {
    static var previews: some View {
        NumberDiffView(title: "Title", diff: "Diff")
    }
}
