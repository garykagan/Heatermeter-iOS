//
//  DigitStepper.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/12/22.
//

import Foundation
import SwiftUI
import Combine

struct DigitStepper: View {
    @Binding var value: Int
    @State var enabled: Bool
    
    @State var lastKnownValue: Int
    var disableable: Bool
    
    init(value: Binding<Int>, disableable: Bool = true) {
        self._value = value
        if disableable {
            self.enabled = value.wrappedValue > -1
        } else {
            self.enabled = true
        }
        self.lastKnownValue = value.wrappedValue
        self.disableable = disableable
    }
    
    var body: some View {
        VStack {
            HStack {
                digitView(digit: \.hundreds)
                digitView(digit: \.tens)
                digitView(digit: \.singles)
            }
            .font(.system(size: 30))
            .padding(.bottom)
            
            if disableable {
                Toggle(isOn: $enabled) {
                    Text("Enabled")
                }
                .toggleStyle(CheckboxToggleStyle())
            }
        }
        .onChange(of: enabled) { newValue in
            withAnimation(.easeOut(duration: 0.1)) {
                if !newValue {
                    self.lastKnownValue = self.value
                    self.value = -1
                } else {
                    self.value = max(lastKnownValue, 0)
                }
            }
        }
        .onChange(of: value) { newValue in
            if disableable {
                enabled = value > -1
            }
        }
    }
    
    func digitView(digit: WritableKeyPath<DecomposedInteger, Digit>) -> some View {
        var decomposed = DecomposedInteger(value: value)
        return VStack {
            Button {
                decomposed[keyPath: digit].increment()
                value = decomposed.projectedValue
            } label: {
                Image(systemName: "chevron.up")
            }
            .buttonStyle(PlainButtonStyle())
            
            Text("\(displayValue(digit: decomposed[keyPath: digit]))")
            
            Button {
                decomposed[keyPath: digit].decrement()
                value = decomposed.projectedValue
            } label: {
                Image(systemName: "chevron.down")
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    func displayValue(digit: Digit) -> String {
        if value > -1 {
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
