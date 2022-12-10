//
//  GraphView.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/5/22.
//

import Foundation
import SwiftUI
import Charts

struct GraphView<ViewModel: GraphViewModel>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        if let samples = viewModel.filteredSamples {
            WindowPickerView(viewModel: viewModel)
                .padding(5)
            
            Chart {
                ForEach(samples) { sample in
                    TemperatureSampleView(sample: sample, sources: viewModel.temperatureSources)
                }
                
                if let (start, end) = viewModel.comparisonRange {
                    RectangleMark(
                        xStart: .value("Selection Start", start),
                        xEnd: .value("Selection End", end)
                    )
                    .foregroundStyle(.gray.opacity(0.2))
                }
            }
            .chartLegend(.visible)
            .chartYAxis {
                AxisMarks(values: .stride(by: viewModel.stride())) {
                    let value = $0.as(Int.self)!
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        Text("\(value.degrees(allowNegative: true))")
                    }
                }
            }
            .chartOverlay { proxy in
                if let (start, end) = viewModel.comparisonRange,
                   let startSample = viewModel.nearestSample(at: start, in: samples),
                   let endSample = viewModel.nearestSample(at: end, in: samples) {
                    VStack {
                        ProbeDiffView(title: "Set Point",
                                      startSample: startSample,
                                      endSample: endSample,
                                      keyPath: \.setPoint)
                        
                        ProbeDiffView(title: "Probe 0",
                                      startSample: startSample,
                                      endSample: endSample,
                                      keyPath: \.probe0Temp)
                        
                        ProbeDiffView(title: "Probe 1",
                                      startSample: startSample,
                                      endSample: endSample,
                                      keyPath: \.probe1Temp)
                        
                        ProbeDiffView(title: "Probe 2",
                                      startSample: startSample,
                                      endSample: endSample,
                                      keyPath: \.probe2Temp)
                        
                        ProbeDiffView(title: "Probe 3",
                                      startSample: startSample,
                                      endSample: endSample,
                                      keyPath: \.probe3Temp)
                        
                        PidDiffView(title: "Fan",
                                    startSample: startSample,
                                    endSample: endSample,
                                    keyPath: \.pidOutputPercent)
                    }
                    .font(.caption2)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                }
                
                GeometryReader { nthGeoItem in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(DragGesture()
                            .onChanged { value in
                                // Find the x-coordinates in the chart’s plot area.
                                let xStart = value.startLocation.x - nthGeoItem[proxy.plotAreaFrame].origin.x
                                let xCurrent = value.location.x - nthGeoItem[proxy.plotAreaFrame].origin.x
                                // Find the date values at the x-coordinates.
                                if let dateStart: Date = proxy.value(atX: xStart),
                                   let dateCurrent: Date = proxy.value(atX: xCurrent) {
                                    viewModel.dragged(start: dateStart, end: dateCurrent)
                                }
                            }
                            .onEnded { _ in viewModel.dragEnded() } // Clear the state on gesture end.
                        )
                }
            }
            .navigationTitle("Graph")
            .navigationBarItems(trailing: Button(action: {
                viewModel.settingsTapped()
            }, label: {
                Image(systemName: "gearshape")
            })
                .popover(isPresented: $viewModel.showingSettings) {
                    GraphSettingsView(viewModel: viewModel)
                }
            )
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 5))
        } else {
            Text("Loading...")
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(viewModel: MockGraphViewModel())
    }
}
