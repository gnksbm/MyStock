//
//  DefaultChartPriceUseCase.swift
//  Domain
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

import RxSwift

public final class DefaultChartPriceUseCase: ChartUseCase {
    @Injected private var oAuthRepository: KISOAuthRepository
    @Injected private var chartPriceRepository: KISChartPriceRepository
    @Injected private var realTimePriceRepository: KISRealTimePriceRepository
    
    public init() { }
    
    public func fetchRealtimeChart(
        period: PeriodType,
        marketType: MarketType,
        ticker: String,
        startDate: String,
        endDate: String
    ) -> Observable<[KISChartPriceResponse]> {
        oAuthRepository.fetchToken(
            request: .init(
                oAuthType: .access,
                investType: .reality
            )
        )
        .withUnretained(self)
        .flatMap { useCase, token in
            useCase.chartPriceRepository.fetchChartData(
                request: .init(
                    investType: .reality,
                    marketType: marketType,
                    period: period,
                    ticker: ticker,
                    startDate: startDate,
                    endDate: endDate,
                    authorization: token.token
                )
            )
        }
        .withLatestFrom(
            oAuthRepository.fetchToken(
                request: .init(
                    oAuthType: .webSocket,
                    investType: .reality
                )
            )
        ) { chartList, token in
            (chartList, token)
        }
        .withUnretained(self)
        .flatMap { useCase, tuple in
            let (chartList, token) = tuple
            var sortedChartList = chartList.sorted { $0.date < $1.date }
            return Observable.merge(
                Observable.just(sortedChartList),
                useCase.realTimePriceRepository.fetchRealTimePrice(
                    request: .init(
                        approvalKey: token.token,
                        ticker: ticker,
                        investType: .reality,
                        marketType: marketType
                    )
                )
                .map { realtimePrice in
                    if let lastChart = sortedChartList.last,
                       let closingPrice = Double(realtimePrice) {
                        sortedChartList.removeLast()
                        let realtimeChart = KISChartPriceResponse(
                            date: lastChart.date,
                            openingPrice: lastChart.openingPrice,
                            highestPrice: lastChart.highestPrice,
                            lowestPrice: lastChart.lowestPrice,
                            closingPrice: closingPrice
                        )
                        sortedChartList.append(realtimeChart)
                    }
                    return sortedChartList
                }
            )
        }
    }
}
