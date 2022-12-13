//
//  ProbeView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/5/22.
//

import Foundation
import SwiftUI

struct ProbeView: View {
    @StateObject var viewModel: ProbeViewModel
    
    var body: some View {
        HStack {
            VStack {
                Text(viewModel.thermometer.name)
                    .font(.largeTitle)
                HStack {
                    Text(viewModel.thermometer.currentTemp.degrees())
                        .bold()
                        .frame(alignment: .leading)
                        .padding(.leading)
                    Spacer()
                    VStack {
                        Text(viewModel.thermometer.alarm.high.degrees(allowNegative: false))
                            .foregroundColor(.orange)
                            .bold()
                        Text(viewModel.thermometer.alarm.low.degrees(allowNegative: false))
                            .foregroundColor(.blue)
                            .bold()
                    }
                    .frame(minWidth: 50)
                    .onTapGesture {
                        print("Tapped set alarms")
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray, lineWidth: 3)
                    )
                    .padding(.trailing)
                }
                Text("\(viewModel.thermometer.degreesPerHour.degrees(allowNegative: true)) / Hour")
            }
            .frame(minWidth: 200, maxWidth: .infinity, minHeight: 120)
            .background(Color(uiColor: .lightGray))
            .foregroundColor(.white)
            .cornerRadius(10)
            
            VStack {
                Button("Start") {
                    print("Tapped start on \(viewModel.thermometer)")
                }

                Text("0")
                Text("Alarm 00:00")
            }
            .frame(minWidth: 100, maxWidth: 110, minHeight: 120)
            .background(Color(uiColor: .lightGray))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .onTapGesture() {
            viewModel.settingsPresented = true
        }
        .sheet(isPresented: $viewModel.settingsPresented) {
            ProbeSettingsView(viewModel: viewModel)
        }
        .shadow(radius: 3.0)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//struct ProbeView_Previews: PreviewProvider {
//    static var previews: some View {
//        let temp = Temp(name: "Brisket",
//                                    currentTemp: 300.50,
//                                    degreesPerHour: 10.0,
//                                    alarm: Alarm(low: 200, high: 300, ringing: nil),
//                                    rf: nil)
//        let viewModel = ProbeViewModel(probe: .probe0, thermometer: temp)
//        
//        ProbeView(viewModel: viewModel)
//    }
//}
