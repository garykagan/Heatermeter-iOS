//
//  Optional+CString.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/4/22.
//

import Foundation

extension Optional where Wrapped == UnsafePointer<CChar> {
    func unwrap(fallback: String = "") -> String {
        let value: String
        if let cValue = self {
            value = String(cString: cValue)
        } else {
            value = fallback
        }
        
        return value
    }
}
