//
//  DefaultKISTopMarketCapRepository.swift
//  Data
//
//  Created by gnksbm on 8/8/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core
import Domain
import Networks

import RxSwift

public final class DefaultKISTopMarketCapRepository: KISTopMarketCapRepository {
    @Injected private var networkService: NetworkService
    
    public init() { }
    
    public func fetchTopVolumeItems(
        request: KISTopMarketCapRequest
    ) -> Observable<[KISTopRankResponse]> {
        networkService.request(
            endPoint: KISTopMarketCapEndpoint(
                request: request
            )
        )
        .map { data in
            let dto = try data.decode(type: KISTopMarketCapDTO.self)
            return dto.toResponse()
        }
    }
}
