//
//  DetailChartView.swift
//  DetailFeature
//
//  Created by gnksbm on 8/10/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import SwiftUI
import Charts

import Domain

extension CandleData: Identifiable {
    public var id: Date { date }
}

final class DetailChartViewModel: ObservableObject {
    @Published var chartDatas: [CandleData] = []
}

struct DetailChartView: View {
    @StateObject var viewModel: DetailChartViewModel
    
    var body: some View {
        Chart(viewModel.chartDatas) {
            AreaMark(
                x: .value("Date", $0.date),
                y: .value("Price", $0.closingPrice)
            )
            .foregroundStyle(by: .value("Food Item", $0.closingPrice))
        }
        .onChange(of: viewModel.chartDatas, perform: { value in
            print(value)
        })
    }
}

extension DetailChartView {
    var toUIKitVC: UIViewController {
        UIHostingController(rootView: self)
    }
}
