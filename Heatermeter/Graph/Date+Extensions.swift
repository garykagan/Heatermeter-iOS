//
//  Date+Extensions.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/6/22.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
