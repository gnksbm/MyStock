//
//  SearchStocksViewModel.swift
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

final class SearchStocksViewModel: ViewModel {
    @Injected(SearchStocksUseCase.self) private var useCase: SearchStocksUseCase
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            searchResult: .init()
        )
        
        input.searchTerm
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, searchTerm in
                    viewModel.useCase.searchStocks(searchTerm: searchTerm)
                }
            )
            .disposed(by: disposeBag)
        
        useCase.searchResult
            .subscribe(
                onNext: {
                    output.searchResult.onNext($0)
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension SearchStocksViewModel {
    struct Input { 
        let searchTerm: Observable<String>
    }
    struct Output { 
        let searchResult: PublishSubject<[KISSearchStocksResponse]>
    }
}
