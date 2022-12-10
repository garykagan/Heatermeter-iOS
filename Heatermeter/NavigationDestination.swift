//
//  NavigationDestination.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/9/22.
//

import Foundation

enum NavigationDestination: Hashable {
  case status(AuthedDevice)
  case graph(AuthedDevice)
}
