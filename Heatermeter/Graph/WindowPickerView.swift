//
//  WindowPickerView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/6/22.
//

import Foundation
import SwiftUI

struct WindowPickerView<ViewModel: GraphViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Picker("Window", selection: $viewModel.window) {
            let windows: [GraphWindow] = [.all, .hour(24), .hour(12), .hour(6), .hour(1)]
            ForEach(windows, id: \.self) {
                switch $0 {
                case .hour(let hours):
                    if hours > 1 {
                        Text("\(hours) Hours")
                    } else {
                        Text("\(hours) Hour")
                    }
                case .all:
                    Text("All")
                }
            }
        }
        .pickerStyle(.segmented)
        .foregroundColor(.black)
    }
}

struct WindowPicker_Previews: PreviewProvider {
    static var previews: some View {
        WindowPickerView(viewModel: MockGraphViewModel())
    }
}
