//
//  DefaultDetailUseCase.swift
//  Domain
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core

import RxSwift

public final class DefaultDetailUseCase: DetailUseCase {
    @Injected private var oAuthRepository: KISOAuthRepository
    @Injected
    private var dailyChartPriceRepository: KISDailyChartPriceRepository
    @Injected private var logoRepository: LogoRepository
    
    @UserDefaultsWrapper(
        key: .userInfo,
        defaultValue: KISUserInfo(
            accountNum: "",
            appKey: "",
            secretKey: ""
        )
    )
    private var userInfo: KISUserInfo
    
    public init() { }
    
    public func fetchDetailItem(
        ticker: String
    ) -> Observable<KISDailyChartPriceResponse> {
        oAuthRepository.fetchToken(
            request: .init(
                oAuthType: .access,
                investType: .reality
            )
        )
        .withUnretained(self)
        .flatMap { useCase, token in
            useCase.dailyChartPriceRepository.fetchDailyChart(
                request: KISDailyChartPriceRequest(
                    ticker: ticker,
                    token: token.token,
                    userInfo: useCase.userInfo
                )
            )
        }
    }
}
