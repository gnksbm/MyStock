//
//  KISRealTimePriceRepository.swift
//  Domain
//
//  Created by gnksbm on 2024/01/04.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import RxSwift

public protocol KISRealTimePriceRepository {
    func fetchRealTimePrice(
        request: KISRealTimePriceRequest
    ) -> Observable<String>
}
