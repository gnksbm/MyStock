//
//  SearchStocksViewModel.swift
//  HomeFeature
//
//  Created by gnksbm on 1/16/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import FeatureDependency
import Domain

import RxSwift

final class SearchStocksViewModel: ViewModel {
    func transform(input: Input) -> Output {
        let output = Output()
        return output
    }
}

extension SearchStocksViewModel {
    struct Input { 
        let searchTerm: Observable<String>
    }
    struct Output { }
}
