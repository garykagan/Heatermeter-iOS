//
//  GraphSettingsView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/9/22.
//

import Foundation
import SwiftUI

struct GraphSettingsView<ViewModel: GraphViewModel>: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .regular {
            VStack {
                items
            }
            .padding()
        } else {
            List {
                items
            }
        }
    }
    
    @ViewBuilder @MainActor var items: some View {
        Toggle("Set Point", isOn: $viewModel.temperatureSources.bind(.setPoint))
        Toggle("Probe 0", isOn: $viewModel.temperatureSources.bind(.probe0))
        Toggle("Probe 1", isOn: $viewModel.temperatureSources.bind(.probe1))
        Toggle("Probe 2", isOn: $viewModel.temperatureSources.bind(.probe2))
        Toggle("Probe 3", isOn: $viewModel.temperatureSources.bind(.probe3))
    }
}

extension Binding where Value: OptionSet, Value == Value.Element {
    func bindedValue(_ options: Value) -> Bool {
        return wrappedValue.contains(options)
    }

    func bind(
        _ options: Value,
        animate: Bool = false
    ) -> Binding<Bool> {
        return .init { () -> Bool in
            self.wrappedValue.contains(options)
        } set: { newValue in
            let body = {
                if newValue {
                    self.wrappedValue.insert(options)
                } else {
                    self.wrappedValue.remove(options)
                }
            }
            guard animate else {
                body()
                return
            }
            withAnimation {
                body()
            }
        }
    }
}

struct GraphSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GraphSettingsView(viewModel: MockGraphViewModel())
    }
}
