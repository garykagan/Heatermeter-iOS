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
            Section {
                TextField("Name", text: $viewModel.name)
                    .foregroundColor(.black)
            }
            
            Section {
                HStack {
                    Spacer()
                    DigitStepper(value: $viewModel.lowValue)
                        .foregroundColor(.blue)
                    Spacer(minLength: 10)
                    DigitStepper(value: $viewModel.highValue)
                        .foregroundColor(.orange)
                    Spacer()
                }
            }
//            
//            VStack {
//                VStack {
//                    Stepper("Low Alarm \(viewModel.currentLow)", value: $viewModel.currentLow) { changed in
////                        viewModel.alarmUpdated()
//                    }
//                }
//                .foregroundColor(.blue)
//                
//                VStack {
//                    Stepper("High Alarm \(viewModel.currentHigh)", value: $viewModel.currentHigh) { changed in
////                        viewModel.alarmUpdated()
//                    }
//                }
//                .foregroundColor(.orange)
//            }
        }
        Text("")
    }
}
