//
//  KISDailyChartPriceRepository.swift
//  Domain
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxSwift

public protocol KISDailyChartPriceRepository {
    func fetchDailyChart(
        request: KISDailyChartPriceRequest
    ) -> Observable<KISDailyChartPriceResponse>
}
