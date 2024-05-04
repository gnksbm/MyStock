//
//  SearchStockViewModel.swift
//  SearchFeature
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
    private let useCase: SearchStocksUseCase
    
    private let disposeBag = DisposeBag()
    
    init(
        useCase: SearchStocksUseCase,
        searchResult: SearchResult,
        coordinator: SearchStockCoordinator
    ) {
        self.useCase = useCase
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
                        viewModel.coordinator.startChartFlow(with: response)
                    case .stockInfo:
                        do {
                            try viewModel.useCase.addFavorites(
                                ticker: response.ticker
                            )
                            viewModel.coordinator.updateFavoritesFinished()
                        } catch {
                            print(error.localizedDescription)
                        }
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
