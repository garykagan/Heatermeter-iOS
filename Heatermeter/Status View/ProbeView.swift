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
            VStack(alignment: .leading) {
                Text(viewModel.thermometer.name)
                    .font(.title)
                HStack {
                    Text(viewModel.thermometer.currentTemp.degrees())
                        .bold()
                        .foregroundColor(.gray)
                }
                .modifier(DisplayReadout())
            }
            .padding(.leading)
            Spacer()
            VStack(alignment: .trailing) {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "thermometer.high")
                        Text(viewModel.thermometer.alarm.high.degrees(allowNegative: false))
                    }
                    .foregroundColor(.orange)
                    .bold()
                    .padding(EdgeInsets(top: 3, leading: 3, bottom: 0, trailing: 3))
                    HStack {
                        Image(systemName: "thermometer.low")
                        Text(viewModel.thermometer.alarm.low.degrees(allowNegative: false))
                    }
                        .foregroundColor(.blue)
                        .bold()
                        .padding(EdgeInsets(top: 0, leading: 3, bottom: 3, trailing: 3))
                }
                .modifier(DisplayReadout())
                .padding([.top, .trailing])
                
                VStack {
                    HStack {
                        VStack {
                            Image(systemName: "thermometer.medium")
                            Image(systemName: "triangle")
                                .font(.system(size: 8))
                        }
                        Text("\(viewModel.thermometer.degreesPerHour.degrees(allowNegative: true)) / Hr")
                    }
                    .bold()
                    .foregroundColor(.teal)
                    .padding()
                    .font(.system(size: 12))
                }
                .modifier(DisplayReadout())
                .padding([.bottom, .trailing])
            }
        }
        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 120)
        .background(Color(uiColor: .lightGray))
        .foregroundColor(.white)
        .cornerRadius(10)
        .onTapGesture() {
            viewModel.probeTapped()
        }
        .sheet(isPresented: $viewModel.settingsPresented) {
            ProbeSettingsView(viewModel: ProbeSettingsViewModel(probe: viewModel.probe,
                                                                service: viewModel.service,
                                                                status: viewModel.status))
        }
        .shadow(radius: 3.0)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct DisplayReadout: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 75)
            .frame(height: 50)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray, lineWidth: 3)
            )
            .cornerRadius(5)
    }
}
