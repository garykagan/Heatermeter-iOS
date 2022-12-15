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
                    .blinkingForeground(colorA: .white, colorB: viewModel.alarmOutlineColor, enabled: viewModel.alarmTriggered)
                    .task {
                        print(viewModel.probe)
                        print(viewModel.alarmTriggered)
                    }
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
                .modifier(DisplayReadout(outlineColor: viewModel.alarmOutlineColor, blinks: viewModel.alarmTriggered))
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
        .overlay(content: {
            RoundedRectangle(cornerRadius: 5)
                .stroke(viewModel.alarmTriggered ? viewModel.alarmOutlineColor : .clear, lineWidth: 5)
                .blinking(enabled: viewModel.alarmTriggered)
        })
    }
}

struct DisplayReadout: ViewModifier {
    var outlineColor: Color
    var blinks: Bool
    
    init(outlineColor: Color = .gray, blinks: Bool = false) {
        self.outlineColor = outlineColor
        self.blinks = blinks
    }
    
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 75)
            .frame(height: 50)
            .background(.white)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(outlineColor, lineWidth: 5)
                    .blinking(enabled: blinks)
            })
            .cornerRadius(5)
    }
}

struct BlinkViewModifier: ViewModifier {
    
    let duration: Double
    let enabled: Bool
    @State private var blinking: Bool = false
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity())
            .animation(.easeOut(duration: duration).repeatForever(), value: blinking)
            .onAppear {
                withAnimation {
                    blinking = true
                }
            }
    }
    
    func opacity() -> Double {
        if enabled {
            return blinking ? 0.0 : 1.0
        } else {
            return 1.0
        }
    }
}

struct BlinkTextColorModifier: ViewModifier {
    
    let duration: Double
    let colorA: Color
    let colorB: Color
    let enabled: Bool
    @State private var blinking: Bool = false
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(color())
            .animation(.easeOut(duration: duration).repeatForever(), value: blinking)
            .onAppear {
                withAnimation {
                    blinking = true
                }
            }
    }
    
    func color() -> Color {
        if enabled {
            return blinking ? colorA : colorB
        } else {
            return colorA
        }
    }
}

extension View {
    func blinking(duration: Double = 0.5, enabled: Bool = true) -> some View {
        modifier(BlinkViewModifier(duration: duration, enabled: enabled))
    }
    
    func blinkingForeground(colorA: Color, colorB: Color, duration: Double = 0.5, enabled: Bool = true) -> some View {
        modifier(BlinkTextColorModifier(duration: duration, colorA: colorA, colorB: colorB, enabled: enabled))
    }
}
