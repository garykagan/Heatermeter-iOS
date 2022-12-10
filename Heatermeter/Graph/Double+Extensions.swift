//
//  Double+Extensions.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/7/22.
//

import Foundation

extension Double {
    static func minimum(_ values: Double?...) -> Double {
        return minimum(values)
    }
    
    static func minimum(_ values: [Double?]) -> Double {
        var min: Double = 0
        for value in values {
            guard let value = value else {
                continue
            }
            min = Double.minimum(min, value)
        }
        
        return min
    }
    
    static func maximum(_ values: Double?...) -> Double {
        return maximum(values)
    }
    
    static func maximum(_ values: [Double?]) -> Double {
        var max: Double = 0
        for value in values {
            guard let value = value else {
                continue
            }
            max = Double.maximum(max, value)
        }
        
        return max
    }
}
