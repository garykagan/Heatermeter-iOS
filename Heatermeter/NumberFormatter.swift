//
//  NumberFormatter.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/5/22.
//

import Foundation
//func percent(_ number: Int?) -> String {
//    guard let number = number else {
//        return "---"
//    }
//
//    guard number.valid() else {
//        return "---"
//    }
//
//    return "\(number)%"
//}
//
//func degrees<N: TemperatureValue>(_ number: N?) -> String {
//    guard let number = number else {
//        return "---"
//    }
//
//    guard number.valid() else {
//        return "---"
//    }
//
//    return "\(number)º"
//}
enum NumberFormatter {
    static func percent(_ number: Int?, allowNegative: Bool) -> String {
        return suffix(number,
                      allowNegative: allowNegative,
                      suffix: "%",
                      fallback: "---")
    }
    
    static func degrees(_ number: Int?, allowNegative: Bool) -> String {
        return suffix(number,
                      allowNegative: allowNegative,
                      suffix: "º",
                      fallback: "---")
    }
    
    static func percent(_ number: Double?, allowNegative: Bool) -> String {
        return suffix(number,
                      allowNegative: allowNegative,
                      suffix: "%",
                      fallback: "---")
    }
    
    static func degrees(_ number: Double?, allowNegative: Bool) -> String {
        return suffix(number,
                      allowNegative: allowNegative,
                      suffix: "º",
                      fallback: "---")
    }
    
    static func suffix(_ number: Double?, allowNegative: Bool, suffix: String, fallback: String) -> String {
        guard let number = number else {
            return fallback
        }
        
        guard allowNegative || number >= 0 else {
            return fallback
        }
        
        return "\(number)\(suffix)"
    }
    
    static func suffix(_ number: Int?, allowNegative: Bool, suffix: String, fallback: String) -> String {
        guard let number = number else {
            return fallback
        }
        
        guard allowNegative || number >= 0 else {
            return fallback
        }
        
        return "\(number)\(suffix)"
    }
}

extension Optional<Int> {
    func percent(allowNegative: Bool = false) -> String {
        return NumberFormatter.percent(self, allowNegative: allowNegative)
    }
    
    func degrees(allowNegative: Bool = true) -> String {
        return NumberFormatter.degrees(self, allowNegative: allowNegative)
    }
}

extension Optional<Double> {
    func percent(allowNegative: Bool = false) -> String {
        return NumberFormatter.percent(self, allowNegative: allowNegative)
    }
    
    func degrees(allowNegative: Bool = true) -> String {
        return NumberFormatter.degrees(self, allowNegative: allowNegative)
    }
}

extension Optional<String> {
    func percent(allowNegative: Bool = false) -> String {
        return self ?? "---"
    }
    
    func degrees(allowNegative: Bool = true) -> String {
        return self ?? "---"
    }
}

extension Int {
    static func percent(_ number: Int?, allowNegative: Bool = false) -> String {
        return NumberFormatter.percent(number, allowNegative: allowNegative)
    }
    
    func percent(allowNegative: Bool = false) -> String {
        return NumberFormatter.percent(self, allowNegative: allowNegative)
    }
    
    static func degrees(_ number: Int?, allowNegative: Bool = true) -> String {
        return NumberFormatter.degrees(number, allowNegative: allowNegative)
    }
    
    func degrees(allowNegative: Bool = true) -> String {
        return NumberFormatter.degrees(self, allowNegative: allowNegative)
    }
}

extension Double {
    static func percent(_ number: Double?, allowNegative: Bool = false) -> String {
        return NumberFormatter.percent(number, allowNegative: allowNegative)
    }
    
    func percent(allowNegative: Bool = false) -> String {
        return NumberFormatter.percent(self, allowNegative: allowNegative)
    }
    
    static func degrees(_ number: Double?, allowNegative: Bool = true) -> String {
        return NumberFormatter.degrees(number, allowNegative: allowNegative)
    }
    
    func degrees(allowNegative: Bool = true) -> String {
        return NumberFormatter.degrees(self, allowNegative: allowNegative)
    }
}
