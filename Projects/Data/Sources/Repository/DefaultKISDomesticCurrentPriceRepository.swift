//
//  DefaultKISDomesticCurrentPriceRepository.swift
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

final class DefaultKISDomesticCurrentPriceRepository: 
    KISDomesticCurrentPriceRepository {
    @Injected private var networkService: NetworkService

    public init() { }

    func fetchCurrentPriceItem(
        request: KISDomesticCurrentPriceRequest
    ) -> Observable<KISCurrentPriceResponse> {
        networkService.request(
            endPoint: KISDomesticCurrentPriceEndPoint(
                request: request
            )
        )
        .map { data in
            let dto = try data.decode(type: KISDomesticCurrentPriceDTO.self)
            return dto.toResponse()
        }
    }
}
