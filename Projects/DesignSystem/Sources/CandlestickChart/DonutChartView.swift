//
//  DonutChartView.swift
//  DesignSystem
//
//  Created by gnksbm on 5/10/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import SwiftUI
import Charts

import Core

@available(iOS 17, *)
struct DonutChartView: View {
    @State private var selectedIndex = 0
    private let chartData: [DonutRepresentable]
    
    init(chartData: [DonutRepresentable]) {
        self.chartData = chartData
    }
    
    var body: some View {
        Chart(chartData, id: \.name) { element in
            let amount = getVolume(value: element.amount)
            SectorMark(
                angle: .value(
                    "name",
                    element.amount
                ),
                innerRadius: .ratio(0.5),
                angularInset: 1.5
            )
            .opacity(
                amount
            )
            .cornerRadius(5)
            .annotation(
                position: .overlay,
                alignment: .center
            ) {
                VStack {
                    Text("\(element.name)")
                    Text(
                        String(
                            format: "%.0f",
                            amount * 100
                        ) + "%"
                    )
                }
            }
        }
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                let numFormatter: NumberFormatter = {
                    let numFormatter = NumberFormatter()
                    numFormatter.numberStyle = .decimal
                    return numFormatter
                }()
                if let plotFrame = chartProxy.plotFrame {
                    let frame = geometry[plotFrame]
                    VStack {
                        Text(chartData[selectedIndex].name)
                        Text(
                            getValue(value: chartData[selectedIndex].amount)
                        )
                    }
                    .position(
                        x: frame.midX,
                        y: frame.midY
                    )
                }
            }
        }
    }
    
    private func getVolume(value: Int) -> Double {
        let maxAmount = chartData.reduce(0) { $0 + $1.amount.f }
        return value.f / maxAmount
    }
    
    private func getValue(value: Int) -> String {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        if let result = numFormatter.string(from: value as NSNumber) {
            return result + "원"
        } else {
            return ""
        }
    }
}

#if DEBUG
struct MockDonutRepresentable: DonutRepresentable {
    static let sample: [Self] = [
        .init(
            name: "data1",
            amount: 30000
        ),
        .init(
            name: "data2",
            amount: 150000
        )
    ]
    let name: String
    let amount: Int
}

@available(iOS 17, *)
#Preview {
    DonutChartView(
        chartData: MockDonutRepresentable.sample
    )
}
#endif
