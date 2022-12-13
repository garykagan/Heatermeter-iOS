//
//  DigitStepper.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/12/22.
//

import Foundation
import SwiftUI
import Combine

class DigitStepperViewModel: ObservableObject {
    @Binding var value: Int
    var enabled: Bool {
        didSet {
            if !enabled {
                self.lastKnownValue = self.value
                self.value = -1
            } else {
                self.value = self.lastKnownValue
            }
            print(enabled)
        }
    }
    
    @Published var lastKnownValue: Int = 0
    
    var enabledCancellable: AnyCancellable? = nil
    
    init(value: Binding<Int>) {
        self._value = value
        
        self.enabled = value.wrappedValue > -1
        self.lastKnownValue = value.wrappedValue
        
    }
}

struct DigitStepper: View {
    @ObservedObject var viewModel: DigitStepperViewModel
    
    init(value: Binding<Int>) {
        self.viewModel = DigitStepperViewModel(value: value)
    }
    
    var body: some View {
        var decomposed = DecomposedInteger(value: viewModel.value)
        VStack {
            HStack {
                VStack {
                    Button {
                        decomposed.hundreds.increment()
                        viewModel.value = decomposed.projectedValue
                    } label: {
                        Image(systemName: "chevron.up")
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text("\(displayValue(digit: decomposed.hundreds))")
                    
                    Button {
                        decomposed.hundreds.decrement()
                        viewModel.value = decomposed.projectedValue
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                VStack {
                    Button {
                        decomposed.tens.increment()
                        viewModel.value = decomposed.projectedValue
                    } label: {
                        Image(systemName: "chevron.up")
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text("\(displayValue(digit: decomposed.tens))")
                    
                    Button {
                        decomposed.tens.decrement()
                        viewModel.value = decomposed.projectedValue
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                VStack {
                    Button {
                        decomposed.singles.increment()
                        viewModel.value = decomposed.projectedValue
                    } label: {
                        Image(systemName: "chevron.up")
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text("\(displayValue(digit: decomposed.singles))")
                    
                    Button {
                        decomposed.singles.decrement()
                        viewModel.value = decomposed.projectedValue
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .font(.system(size: 30))
            .padding(.bottom)
            
            Toggle(isOn: $viewModel.enabled) {
                Text("Enabled")
            }
            .toggleStyle(CheckboxToggleStyle())
        }
    }
    
    func displayValue(digit: Digit) -> String {
        if viewModel.value > -1 {
            return "\(digit.value)"
        } else {
            return "-"
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            configuration.label
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 22, height: 22)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

struct DecomposedInteger {
    var singles: Digit
    var tens: Digit
    var hundreds: Digit
    
    var projectedValue: Int {
        return singles.projectedValue + tens.projectedValue + hundreds.projectedValue
    }
    
    init(value: Int) {
        let hundresRemainder = value % 100
        self.hundreds = Digit(value: (value - hundresRemainder) / 100, multiplier: 100)
        let tensRemainder = hundresRemainder % 10
        self.tens = Digit(value: (hundresRemainder - tensRemainder) / 10, multiplier: 10)
        self.singles = Digit(value: tensRemainder, multiplier: 1)
    }
}

struct Digit {
    var value: Int
    var multiplier: Int
    
    var projectedValue: Int {
        value * multiplier
    }
    
    var display: String {
        return "\(value)"
    }
    
    mutating func increment() {
        if value >= 9 {
            value = 0
        } else {
            value += 1
        }
    }
    
    mutating func decrement() {
        if value <= 0 {
            value = 9
        } else {
            value -= 1
        }
    }
}

struct DigitStepper_Previews: PreviewProvider {
    @State static var value: Int = 987
    
    static var previews: some View {
        DigitStepper(value: $value)
    }
}
