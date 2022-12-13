//
//  Device.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/12/22.
//

import Foundation

protocol Device: Codable, Hashable, Identifiable {
    var host: String { get }
}
