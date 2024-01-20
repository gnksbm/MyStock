//
//  SearchStocksRepository.swift
//  Domain
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxSwift

public protocol SearchStocksRepository {
    func searchStocks(
        searchTerm: String
    ) -> Observable<[KISSearchStocksResponse]>
}
