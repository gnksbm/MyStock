//
//  SearchStockViewModel.swift
//  HomeFeature
//
//  Created by gnksbm on 1/16/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import FeatureDependency
import Core
import Domain

import RxSwift
import RxRelay

final class SearchStockViewModel: ViewModel {
    private let searchResult: SearchResult
    private let coordinator: SearchStockCoordinator
    @Injected(SearchStocksUseCase.self) private var useCase: SearchStocksUseCase
    
    private let disposeBag = DisposeBag()
    
    init(
        searchResult: SearchResult,
        coordinator: SearchStockCoordinator
    ) {
        self.searchResult = searchResult
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            searchResult: .init(value: [])
        )
        
        input.searchTerm
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, searchTerm in
                    viewModel.useCase.searchStocks(searchTerm: searchTerm)
                }
            )
            .disposed(by: disposeBag)
        
        input.stockCellTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, index in
                    let response = output.searchResult.value[index]
                    switch viewModel.searchResult {
                    case .chart:
                        viewModel.coordinator.pushToChartVC(with: response)
                    case .stockInfo:
                        viewModel.useCase.addFavorites(ticker: response.ticker)
                        viewModel.coordinator.updateFavoritesFinished()
                    }
                }
            )
            .disposed(by: disposeBag)
        
        useCase.searchResult
            .subscribe(
                onNext: {
                    output.searchResult.accept($0)
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension SearchStockViewModel {
    struct Input { 
        let searchTerm: Observable<String>
        let stockCellTapEvent: Observable<Int>
    }
    struct Output { 
        let searchResult: BehaviorRelay<[SearchStocksResponse]>
    }
}
