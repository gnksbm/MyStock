//
//  DefaultHomeUseCase.swift
//  Domain
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public final class DefaultHomeUseCase: HomeUseCase {
    private let oAuthRepository: KISOAuthRepository
    private let checkBalanceRepository: KISCheckBalanceRepository
    private let disposeBag = DisposeBag()
    
    public let balanceInfo = PublishSubject<[KISCheckBalanceResponse]>()
    
    public init(
        oAuthRepository: KISOAuthRepository,
        checkBalanceRepository: KISCheckBalanceRepository
    ) {
        self.oAuthRepository = oAuthRepository
        self.checkBalanceRepository = checkBalanceRepository
    }
    
    public func checkAccount(
        accountNumber: String
    ) {
        oAuthRepository.accessToken
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, token in
                    useCase.checkBalanceRepository.requestBalance(
                        request: .init(
                            investType: .reality,
                            marketType: .domestic,
                            accountNumber: accountNumber
                        ),
                        authorization: token.token
                    )
                }
            )
            .disposed(by: disposeBag)
        
        checkBalanceRepository.fetchResult
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, result in
                    useCase.balanceInfo.onNext(result.combineSameTiker)
                }
            )
            .disposed(by: disposeBag)
        
        oAuthRepository.requestOAuth(
            request: .init(
                oAuthType: .access,
                investType: .reality
            )
        )
    }
}
