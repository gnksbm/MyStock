//
//  DefaultLogoRepository.swift
//  Data
//
//  Created by gnksbm on 5/5/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Core
import Domain
import Networks

import RxSwift

public final class DefaultLogoRepository: LogoRepository {
    @Injected(NetworkService.self)
    private var networkService: NetworkService
    
    public init() { }
    
    public func fetchLogo(request: LogoRequest) -> Observable<LogoResponse> {
        let endPoint = LogoEndPoint(request: request)
        return networkService.requestWithCache(endPoint: endPoint)
            .map { data in
                LogoResponse(
                    ticker: request.ticker,
                    logo: UIImage(data: data)
                )
            }
    }
}
