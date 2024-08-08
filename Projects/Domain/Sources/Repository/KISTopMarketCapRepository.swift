//
//  KISTopMarketCapRepository.swift
//  Domain
//
//  Created by gnksbm on 8/8/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxSwift

public protocol KISTopMarketCapRepository {
    func fetchTopMarketCapItems(
        request: KISTopMarketCapRequest
    ) -> Observable<[KISTopRankResponse]>
}
