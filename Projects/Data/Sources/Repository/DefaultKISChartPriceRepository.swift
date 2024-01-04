//
//  DefaultKISChartPriceRepository.swift
//  Data
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain
import Networks

import RxSwift

public final class DefaultKISChartPriceRepository: KISChartPriceRepository {
    private let networkService: NetworkService
    private let disposeBag = DisposeBag()
    
    public var chartResponse = PublishSubject<[Candle]>()
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func requestChartData(
        request: KISChartPriceRequest
    ) {
        networkService.request(
            endPoint: KISChartPriceEndPoint(
                investType: request.investType,
                period: request.period,
                ticker: request.ticker,
                startDate: request.startDate,
                endDate: request.endDate,
                authorization: request.authorization
            )
        )
        .compactMap {
            try? $0.decode(type: KISChartPriceDTO.self).toDomain
        }
        .withUnretained(self)
        .subscribe(
            onNext: { repository, response in
                repository.chartResponse.onNext(response)
            },
            onError: {
                print(
                "\(String(describing: self)): \($0.localizedDescription)"
                )
            }
        )
        .disposed(by: disposeBag)
    }
}
