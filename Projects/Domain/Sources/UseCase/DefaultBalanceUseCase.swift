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
    @Injected(KISOAuthRepository.self)
    private var oAuthRepository: KISOAuthRepository
    @Injected(KISBalanceRepository.self)
    private var checkBalanceRepository: KISBalanceRepository
    @Injected(LogoRepository.self)
    private var logoRepository: LogoRepository
    
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
                    accountNumber: .accountNumber
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
                            markeyType: .domestic
                        )
                    )
                }
            )
            .map { ($0, responses, collateralRatio) }
        }
        .map { tuple in
            let (logoArr, balanceArr, collateralRatio) = tuple
            var logoDic = [String: UIImage?]()
            
            logoArr.forEach { logoResponse in
                logoDic[logoResponse.ticker] = logoResponse.image
            }
            
            let resultBalance = balanceArr.map { balance in
                var newBalance = balance
                if let logoImage = logoDic[balance.ticker] {
                    newBalance.image = logoImage
                }
                return newBalance
            }
            return (collateralRatio, resultBalance)
        }
    }
}
