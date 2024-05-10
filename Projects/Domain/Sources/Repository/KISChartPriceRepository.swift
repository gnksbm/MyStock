//
//  KISChartPriceRepository.swift
//  Domain
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

import RxSwift

public protocol KISChartPriceRepository {
    func fetchChartData(
        request: KISChartPriceRequest
    ) -> Observable<[KISChartPriceResponse]>
}
