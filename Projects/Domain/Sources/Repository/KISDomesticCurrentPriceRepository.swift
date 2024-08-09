//
//  KISDomesticCurrentPriceRepository.swift
//  Domain
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxSwift

public protocol KISDomesticCurrentPriceRepository {
    func fetchCurrentPriceItem(
        request: KISDomesticCurrentPriceRequest
    ) -> Observable<KISCurrentPriceResponse>
}
