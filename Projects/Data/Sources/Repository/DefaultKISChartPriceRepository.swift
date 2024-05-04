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
    
    public var chartResponse = PublishSubject<[KISChartPriceResponse]>()
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func requestChartData(
        request: KISChartPriceRequest
    ) {
        networkService.request(
            endPoint: KISChartPriceEndPoint(
                investType: request.investType,
                marketType: request.marketType,
                period: request.period,
                ticker: request.ticker,
                startDate: request.startDate,
                endDate: request.endDate,
                authorization: request.authorization
            )
        )
        .compactMap {
            switch request.marketType {
            case .overseas:
                try? $0.decode(type: KISOverseasChartPriceDTO.self).toDomain
            case .domestic:
                try? $0.decode(type: KISDomesticChartPriceDTO.self).toDomain
            }
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
