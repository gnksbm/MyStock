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
    @Injected private var networkService: NetworkService
    
    public init() { }
    
    public func fetchChartData(
        request: KISChartPriceRequest
    ) -> Observable<[CandleData]> {
        networkService.request(
            endPoint: KISChartPriceEndPoint(
                request: request
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
    }
}
