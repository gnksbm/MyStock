//
//  DefaultKISDailyChartPriceRepository.swift
//  Data
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core
import Domain
import Networks

import RxSwift

public final class DefaultKISDailyChartPriceRepository: 
    KISDailyChartPriceRepository {
    @Injected private var networkService: NetworkService
    
    public init() { }

    public func fetchDailyChart(
        request: KISDailyChartPriceRequest
    ) -> Observable<KISDailyChartPriceResponse> {
        networkService.request(
            endPoint: KISDailyChartPriceEndPoint(
                request: request
            )
        )
        .map { data in
            let dto = try data.decode(type: KISDailyChartPriceDTO.self)
            return dto.toResponse(ticker: request.ticker)
        }
    }
}
