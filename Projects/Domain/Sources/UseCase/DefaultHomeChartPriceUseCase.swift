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
    public var chartInfo = PublishSubject<[Candle]>()
    
    private let oAuthRepository: KISOAuthRepository
    private let chartPriceRepository: KISChartPriceRepository
    private let disposeBag = DisposeBag()
    
    public init(
        oAuthRepository: KISOAuthRepository,
        chartPriceRepository: KISChartPriceRepository
    ) {
        self.oAuthRepository = oAuthRepository
        self.chartPriceRepository = chartPriceRepository
    }
    
    public func fetchChart(
        period: PeriodType,
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
        
        oAuthRepository.requestOAuth(
            request: .init(
                oAuthType: .access,
                investType: .reality
            )
        )
    }
}
