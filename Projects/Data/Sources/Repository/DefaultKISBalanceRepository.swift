//
//  DefaultKISBalanceRepository.swift
//  Data
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain
import Networks

import RxSwift

public final class DefaultKISBalanceRepository: KISBalanceRepository {
    @Injected private var networkService: NetworkService
    
    public init() { }

    deinit {
        #if DEBUG
        print(
            String(describing: self),
            ": deinit"
        )
        #endif
    }
    
    public func fetchBalance(
        request: KISCheckBalanceRequest,
        authorization: String
    ) -> Observable<(collateralRatio: Double, [KISCheckBalanceResponse])> {
        networkService.request(
            endPoint: KISCheckBalanceEndPoint(
                investType: request.investType,
                query: request.toQuery,
                authorization: authorization
            )
        )
        .decode(
            type: KISCheckBalanceDTO.self,
            decoder: JSONDecoder()
        )
        .map {
            ($0.collateralRatio, $0.toDomain(marketType: request.marketType))
        }
    }
}
