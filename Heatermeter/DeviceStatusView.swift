//
//  DeviceStatusView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/5/22.
//

import SwiftUI

struct DeviceStatusView: View {
    @State var viewModel: any DeviceViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    HStack {
                        Text("Set Point")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text(viewModel.status.setPoint.degrees())
                            .font(.title2)
                            .foregroundColor(.yellow)
                            .bold()
                    }
                    HStack {
                        VStack {
                            Text("Fan")
                            Text(viewModel.status.fan.outputPercentage.percent())
                        }
                        .foregroundColor(.indigo)
                        VStack {
                            Text("Avg")
                            Text(
                                viewModel
                                .status
                                .fan
                                .averageOutputPercentage
                                .degrees()
                            )
                        }
                        .foregroundColor(.purple)
                    }
                    .bold()
                    .padding()
                    .frame(maxHeight: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.white, lineWidth: 3)
                    )
                }
                .frame(maxWidth: .infinity, minHeight: 120)
                .background(Color(uiColor: .lightGray))
                .cornerRadius(10)
                .padding(5)
                
                if let status = viewModel.status {
                    ForEach(status.temps) { temp in
                        ProbeView(viewModel: ProbeViewModel(thermometer: temp))
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                    }
                }
            }
        }
    }
}


struct DeviceStatusView_Previews: PreviewProvider {
    static let json = """
{
    "time": 1670278367,
    "set": 230,
    "lid": 0,
    "fan": {
        "c": 100,
        "a": 99,
        "f": 100,
        "s": 100
    },
    "adc": [0, 1, 0, 1, 0, 0],
    "temps": [{
        "n": "Pit",
        "c": 73.8,
        "a": {
            "l": -1,
            "h": -1,
            "r": null
        }
    }, {
        "n": "Pit",
        "c": 73.8,
        "a": {
            "l": 200,
            "h": 300,
            "r": null
        }
    }, {
        "n": "Brisket",
        "c": 73.0,
        "a": {
            "l": -1,
            "h": -1,
            "r": null
        }
    }, {
        "n": "Probe 3",
        "c": null,
        "a": {
            "l": -1,
            "h": -1,
            "r": null
        }
    }]
}
""".data(using: .utf8)!
    
    static var previews: some View {
        let device = Device(name: "device",
                            host: "device.local",
                            port: 1)
        let status = try! JSONDecoder().decode(CurrentStatus.self, from: json)
        let viewModel = MockDeviceViewModel(device: device,
                                            status: status)
        DeviceStatusView(viewModel: viewModel)
    }
}
