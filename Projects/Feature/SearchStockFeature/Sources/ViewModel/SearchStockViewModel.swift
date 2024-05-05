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
    private let searchFlow: SearchFlow
    private let coordinator: SearchStockCoordinator
    private let useCase: SearchStocksUseCase
    
    private let disposeBag = DisposeBag()
    
    init(
        useCase: SearchStocksUseCase,
        searchResult: SearchFlow,
        coordinator: SearchStockCoordinator
    ) {
        self.useCase = useCase
        self.searchFlow = searchResult
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            searchResult: .init(value: [])
        )
        
        input.searchTerm
            .withUnretained(self)
            .flatMap { viewModel, searchTerm in
                viewModel.useCase.searchStocks(searchTerm: searchTerm)
            }
            .bind(to: output.searchResult)
            .disposed(by: disposeBag)
        
        input.stockCellTapEvent
            .withUnretained(self)
            .filter { vm, _ in
                vm.searchFlow == .chart
            }
            .bind(
                onNext: { vm, stocks in
                    vm.coordinator.startChartFlow(with: stocks)
                }
            )
            .disposed(by: disposeBag)
        
        input.stockCellTapEvent
            .withUnretained(self)
            .filter { vm, _ in
                vm.searchFlow == .stockInfo
            }
            .flatMap { vm, stocks in
                vm.useCase.addFavorites(
                    ticker: stocks.ticker
                )
            }
            .withUnretained(self)
            .subscribe(
                onNext: { vm, _ in
                    vm.coordinator.updateFavoritesFinished()
                },
                onError: { [weak self] error in
                    self?.coordinator.showError(
                        error: error
                    )
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension SearchStockViewModel {
    struct Input { 
        let searchTerm: Observable<String>
        let stockCellTapEvent: Observable<SearchStocksResponse>
    }
    struct Output { 
        let searchResult: BehaviorRelay<[SearchStocksResponse]>
    }
}
