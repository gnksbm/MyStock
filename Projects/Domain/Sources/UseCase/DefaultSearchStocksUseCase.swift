//
//  DefaultSearchStocksUseCase.swift
//  Domain
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxSwift

public final class DefaultSearchStocksUseCase: SearchStocksUseCase {
    private let repository: SearchStocksRepository
    private let disposeBag = DisposeBag()
    public let searchResult = PublishSubject<[SearchStocksResponse]>()
    
    public init(repository: SearchStocksRepository) {
        self.repository = repository
    }
    
    public func searchStocks(searchTerm: String) {
        repository.searchStocks(searchTerm: searchTerm)
            .withUnretained(self)
            .subscribe { useCase, results in
                useCase.searchResult.onNext(results)
            }
            .disposed(by: disposeBag)
    }
}
