//
//  DefaultKISTopVolumeRepository.swift
//  Data
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core
import Domain
import Networks

import RxSwift

public final class DefualtKISTopVolumeRepository: KISTopVolumeRepository {
    @Injected private var networkService: NetworkService
    
    public init() { }
    
    public func fetchTopVolumeItems(
        request: KISTopVolumeRequest
    ) -> Observable<[KISTopVolumeResponse]> {
        networkService.request(
            endPoint: KISTopVolumeEndpoint(
                request: request
            )
        )
        .map { data in
            let dto = try data.decode(type: KISTopVolumeDTO.self)
            return dto.toResponse()
        }
    }
}
