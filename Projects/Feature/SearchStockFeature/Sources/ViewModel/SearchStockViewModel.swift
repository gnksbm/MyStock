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
    @Injected(SearchStocksUseCase.self) private var useCase: SearchStocksUseCase
    
    private let disposeBag = DisposeBag()
    private let coordinator: SearchStockCoordinator
    
    init(coordinator: SearchStockCoordinator) {
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
                    viewModel.coordinator.pushToChartVC(with: response)
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
