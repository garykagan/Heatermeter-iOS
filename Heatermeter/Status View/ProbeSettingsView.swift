//
//  SetAlarmView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/10/22.
//

import Foundation
import SwiftUI

struct ProbeSettingsView: View {
    @StateObject var viewModel: ProbeViewModel
    
    var body: some View {
        Form {
            TextField("Name", text: $viewModel.name) { _ in
                viewModel.nameUpdated()
            }
            .foregroundColor(.black)
            
            VStack {
                VStack {
                    Stepper("Low Alarm \(viewModel.currentLow)", value: $viewModel.currentLow) { changed in
                        viewModel.alarmUpdated()
                    }
                }
                .foregroundColor(.blue)
                
                VStack {
                    Stepper("High Alarm \(viewModel.currentHigh)", value: $viewModel.currentHigh) { changed in
                        viewModel.alarmUpdated()
                    }
                }
                .foregroundColor(.orange)
            }
        }
    }
}
