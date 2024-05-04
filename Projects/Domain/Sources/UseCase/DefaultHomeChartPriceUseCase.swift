//
//  DefaultHomeChartPriceUseCase.swift
//  Domain
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

import RxSwift

public final class DefaultHomeChartPriceUseCase: HomeChartUseCase {
    public var chartInfo = PublishSubject<[KISChartPriceResponse]>()
    
    @Injected(KISOAuthRepository.self)
    private var oAuthRepository: KISOAuthRepository
    @Injected(KISChartPriceRepository.self)
    private var chartPriceRepository: KISChartPriceRepository
    @Injected(KISRealTimePriceRepository.self)
    private var realTimePriceRepository: KISRealTimePriceRepository
    private let disposeBag = DisposeBag()
    
    public init() { }
    
    public func fetchRealtimeChart(
        period: PeriodType,
        marketType: MarketType,
        ticker: String,
        startDate: String,
        endDate: String
    ) {
        oAuthRepository.accessToken
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, token in
                    useCase.chartPriceRepository.requestChartData(
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
            )
            .disposed(by: disposeBag)
        
        chartPriceRepository.chartResponse
            .withUnretained(self)
            .subscribe { useCase, response in
                useCase.chartInfo.onNext(response)
            }
            .disposed(by: disposeBag)
        
        oAuthRepository.wsToken
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, token in
                    useCase.realTimePriceRepository.requestData(
                        request: .init(
                            approvalKey: token.token,
                            ticker: ticker,
                            investType: .reality,
                            marketType: marketType
                        )
                    )
                }
            )
            .disposed(by: disposeBag)
        
        realTimePriceRepository.price
            .withLatestFrom(chartInfo) { realTimePrice, chartData in
                (realTimePrice, chartData)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, tuple in
                    let (realTimePrice, chartData) = tuple
                    var sortedChartData = chartData.sorted(
                        by: { $0.date < $1.date }
                    )
                    if let todayResponse = sortedChartData.last,
                       !realTimePrice.isEmpty {
                        guard let closingPrice = Double(realTimePrice)
                        else { return }
                        let oldResponse = sortedChartData.removeLast()
                        let newResponse = KISChartPriceResponse(
                            date: oldResponse.date,
                            openingPrice: oldResponse.openingPrice,
                            highestPrice: oldResponse.highestPrice,
                            lowestPrice: oldResponse.lowestPrice,
                            closingPrice: closingPrice
                        )
                        sortedChartData.append(newResponse)
                    }
                    useCase.chartInfo.onNext(sortedChartData)
                }
            )
            .disposed(by: disposeBag)
        
        oAuthRepository.requestOAuth(
            request: .init(
                oAuthType: .access,
                investType: .reality
            )
        )
        
        oAuthRepository.requestOAuth(
            request: .init(
                oAuthType: .webSocket,
                investType: .reality
            )
        )
    }
    
    public func disconnectRealTimePrice() {
        realTimePriceRepository.disconnectSocket()
    }
}
