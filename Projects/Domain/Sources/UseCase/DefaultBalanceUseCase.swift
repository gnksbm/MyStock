//
//  DefaultBalanceUseCase.swift
//  Domain
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import UIKit

import Core

import RxSwift

public final class DefaultBalanceUseCase: BalanceUseCase {
    @Injected private var oAuthRepository: KISOAuthRepository
    @Injected private var checkBalanceRepository: KISBalanceRepository
    @Injected private var logoRepository: LogoRepository
    
    @UserDefaultsWrapper(
        key: "kisUserInfo",
        defaultValue: KISUserInfo(
            accountNum: "",
            appKey: "",
            secretKey: ""
        )
    )
    private var userInfo: KISUserInfo
    
    public init() { }
    
    public func fetchBalance(
    ) -> Observable<(collateralRatio: Double, [KISCheckBalanceResponse])> {
        oAuthRepository.fetchToken(
            request: .init(
                oAuthType: .access,
                investType: .reality
            )
        )
        .withUnretained(self)
        .flatMap { useCase, token in
            useCase.checkBalanceRepository.fetchBalance(
                request: .init(
                    investType: .reality,
                    marketType: .domestic,
                    accountNumber: useCase.userInfo.accountNum
                ),
                authorization: token.token
            )
        }
        .withUnretained(self)
        .flatMap { useCase, tuple in
            let (collateralRatio, responses) = tuple
            return Observable.zip(
                responses.map { response in
                    useCase.logoRepository.fetchLogo(
                        request: .init(
                            ticker: response.ticker,
                            marketType: .domestic
                        )
                    )
                }
            )
            .map { ($0, responses, collateralRatio) }
        }
        .map { logoArr, balanceArr, collateralRatio in
            let resultBalance = logoArr.updateWithLogo(list: balanceArr)
            return (collateralRatio, resultBalance)
        }
    }
}
