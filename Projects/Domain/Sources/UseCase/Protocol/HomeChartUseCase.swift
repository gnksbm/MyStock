//
//  HomeChartUseCase.swift
//  Domain
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

import RxSwift

public protocol HomeChartUseCase {
    var chartInfo: PublishSubject<[KISChartPriceResponse]> { get }
    
    func fetchRealtimeChart(
        period: PeriodType,
        marketType: MarketType,
        ticker: String,
        startDate: String,
        endDate: String
    )
    
    func disconnectRealTimePrice()
}
