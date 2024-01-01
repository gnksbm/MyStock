//
//  HomeChartViewModel.swift
//  HomeFeature
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain

import RxSwift

final class HomeChartViewModel {
    @Injected(HomeChartUseCase.self) private var useCase: HomeChartUseCase
    let ticker: String
    
    init(ticker: String) {
        self.ticker = ticker
        useCase.fetchChart(
            period: .day,
            ticker: ticker,
            startDate: "20231127",
            endDate: "20231228"
        )
    }
}
