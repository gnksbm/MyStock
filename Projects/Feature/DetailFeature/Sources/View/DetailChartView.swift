//
//  DetailChartView.swift
//  DetailFeature
//
//  Created by gnksbm on 8/10/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import SwiftUI
import Charts

import DesignSystem
import Domain

extension CandleData: Identifiable {
    public var id: Date { date }
}

final class DetailChartViewModel: ObservableObject {
    @Published var chartDatas: [CandleData] = []
    
    var lowestPrice: Double {
        guard let min = chartDatas.map { $0.closingPrice }.min()
        else { return 0 }
        return min
    }
    
    var chartRange: ClosedRange<Double> {
        let arr = chartDatas.map { $0.closingPrice }
        guard let min = arr.min(),
              let max = arr.max() else { return 0...0 }
        return min...max
    }
}

struct DetailChartView: View {
    @StateObject var viewModel: DetailChartViewModel
    
    var body: some View {
        Chart(viewModel.chartDatas) {
            AreaMark(
                x: .value("Date", $0.date),
                yStart: .value("Price", viewModel.lowestPrice),
                yEnd: .value("Price", $0.closingPrice)
            )
            .foregroundStyle(
                .linearGradient(
                    colors: [
                        DesignSystemAsset.whiteCandle.swiftUIColor,
                        .clear
                    ],
                    startPoint: .top, 
                    endPoint: .bottom
                )
            )
            LineMark(
                x: .value("Date", $0.date),
                y: .value("Price", $0.closingPrice)
            )
            .foregroundStyle(DesignSystemAsset.whiteCandle.swiftUIColor)
        }
        .contentTransition(.interpolate)
        .clipped()
        .chartYScale(
            domain: viewModel.chartRange,
            range: .plotDimension(padding: 10)
        )
    }
}

extension DetailChartView {
    var toUIKitVC: UIViewController {
        UIHostingController(rootView: self)
    }
}
