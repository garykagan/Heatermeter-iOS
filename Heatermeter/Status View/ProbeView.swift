//
//  ProbeView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/5/22.
//

import Foundation
import SwiftUI

struct ProbeView: View {
    @ObservedObject var viewModel: ProbeViewModel
    @EnvironmentObject var theme: Theme
    
    var alarmOutlineColor: Color {
        guard let ringType = viewModel.thermometer.activeAlarm else {
            return .gray
        }
        
        switch ringType {
        case .high:
            return theme.high
        case .low:
            return theme.low
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    if viewModel.alarmTriggered && viewModel.activeAlarm == .high {
                        Text(viewModel.thermometer.name)
                            .font(.title)
                            .blinkingForeground(colorA: theme.title,
                                                colorB: alarmOutlineColor,
                                                enabled: viewModel.alarmTriggered)
                        Image(systemName: "bell.and.waves.left.and.right")
                            .blinkingForeground(colorA: theme.title,
                                                colorB: alarmOutlineColor,
                                                enabled: viewModel.alarmTriggered)
                    } else if viewModel.alarmTriggered && viewModel.activeAlarm == .low {
                        Text(viewModel.thermometer.name)
                            .font(.title)
                            .blinkingForeground(colorA: theme.title,
                                                colorB: alarmOutlineColor,
                                                enabled: viewModel.alarmTriggered)
                        Image(systemName: "bell.and.waves.left.and.right")
                            .blinkingForeground(colorA: theme.title,
                                                colorB: alarmOutlineColor,
                                                enabled: viewModel.alarmTriggered)
                    } else {
                        Text(viewModel.thermometer.name)
                            .font(.title)
                            .foregroundColor(theme.title)
                    }
                }
                HStack {
                    Text(viewModel.thermometer.currentTemp.degrees())
                        .bold()
                        .foregroundColor(theme.currentTemp)
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
                    .foregroundColor(theme.high)
                    .bold()
                    .padding(EdgeInsets(top: 3, leading: 3, bottom: 0, trailing: 3))
                    HStack {
                        Image(systemName: "thermometer.low")
                        Text(viewModel.thermometer.alarm.low.degrees(allowNegative: false))
                    }
                    .foregroundColor(theme.low)
                    .bold()
                    .padding(EdgeInsets(top: 0, leading: 3, bottom: 3, trailing: 3))
                }
                .modifier(DisplayReadout(outlineColor: alarmOutlineColor,
                                         blinks: viewModel.alarmTriggered))
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
                    .foregroundColor(theme.degreesPerHour)
                    .padding()
                    .font(.system(size: 12))
                }
                .modifier(DisplayReadout())
                .padding([.bottom, .trailing])
            }
        }
        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 120)
        .background(theme.tileBackground)
        .foregroundColor(theme.title)
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
            if viewModel.alarmTriggered {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(viewModel.alarmTriggered ? alarmOutlineColor : .clear,
                            lineWidth: 5)
                    .blinking(enabled: viewModel.alarmTriggered)
            }
        })
    }
}

struct DisplayReadout: ViewModifier {
    @EnvironmentObject var theme: Theme
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
            .background(theme.displayBackground)
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
