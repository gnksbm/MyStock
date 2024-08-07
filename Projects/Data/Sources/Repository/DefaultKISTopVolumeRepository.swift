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

final class DefaultKISTopVolumeRepository: KISTopVolumeRepository {
    @Injected private var networkService: NetworkService
    
    func fetchTopVolumeItems(
        request: KISTopVolumeRequest
    ) -> Observable<[KISTopVolumeResponse]> {
        networkService.request(
            endPoint: KISTopVolumeEndpoint(
                request: request
            )
        )
        .decode(type: KISTopVolumeDTO.self, decoder: JSONDecoder())
        .map { $0.toResponse() }
    }
}
