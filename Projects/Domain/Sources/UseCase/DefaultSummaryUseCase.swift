//
//  DefaultSummaryUseCase.swift
//  Domain
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Core

import RxSwift

public final class DefaultSummaryUseCase: SummaryUseCase {
    @Injected private var oAuthRepository: KISOAuthRepository
    @Injected private var topMarketCapRepository: KISTopMarketCapRepository
    @Injected private var topVolumeRepository: KISTopVolumeRepository
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
    
    public func fetchTopVolumeItems() -> Observable<[KISTopRankResponse]> {
        oAuthRepository.fetchToken(
            request: .init(
                oAuthType: .access,
                investType: .reality
            )
        )
        .withUnretained(self)
        .flatMap { useCase, token in
            useCase.topVolumeRepository.fetchTopVolumeItems(
                request: KISTopVolumeRequest(
                    token: token.token,
                    userInfo: useCase.userInfo
                )
            )
        }
//        .withUnretained(self)
//        .flatMap { useCase, items in
//            Observable.zip(
//                items.map { item in
//                    useCase.logoRepository.updateLogo(
//                        from: item,
//                        request: .init(
//                            ticker: item.ticker,
//                            marketType: .domestic
//                        )
//                    )
//                }
//            )
//        }
    }
    
    public func fetchTopMarketCapItems() -> Observable<[KISTopRankResponse]> {
        oAuthRepository.fetchToken(
            request: .init(
                oAuthType: .access,
                investType: .reality
            )
        )
        .withUnretained(self)
        .flatMap { useCase, token in
            useCase.topMarketCapRepository.fetchTopMarketCapItems(
                request: KISTopMarketCapRequest(
                    token: token.token,
                    userInfo: useCase.userInfo
                )
            )
        }
//        .withUnretained(self)
//        .flatMap { useCase, items in
//            Observable.zip(
//                items.map { item in
//                    useCase.logoRepository.updateLogo(
//                        from: item,
//                        request: .init(
//                            ticker: item.ticker,
//                            marketType: .domestic
//                        )
//                    )
//                }
//            )
//        }
    }
}
