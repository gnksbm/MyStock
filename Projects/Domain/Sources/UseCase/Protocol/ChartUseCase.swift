//
//  ChartUseCase.swift
//  Domain
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

import RxSwift

public protocol ChartUseCase {
    func fetchRealtimeChart(
        period: PeriodType,
        marketType: MarketType,
        ticker: String,
        startDate: String,
        endDate: String
    ) -> Observable<[KISChartPriceResponse]>
}
