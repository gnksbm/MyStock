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

import ReactorKit

final class SearchStockReactor: Reactor {
    private let searchFlow: SearchFlow
    private let coordinator: SearchStockCoordinator
    private let useCase: SearchStocksUseCase
    
    var initialState = State()
    
    init(
        useCase: SearchStocksUseCase,
        searchFlow: SearchFlow,
        coordinator: SearchStockCoordinator
    ) {
        self.useCase = useCase
        self.searchFlow = searchFlow
        self.coordinator = coordinator
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchTermChangeEvent(let searchTerm):
            guard !searchTerm.isEmpty else { return .empty() }
            return .concat(
                .just(.setSearching(true)),
                useCase.searchStocks(searchTerm: searchTerm)
                .map { .search(searchResult: $0) },
                .just(.setSearching(false))
            )
        case .stockCellTapEvent(let searchResult):
            return .just(.startChartFlow(searchResult))
        case .likeButtonTapEvent(let item):
            return useCase.updateFavorites(item: item)
                .map { .addFavorites($0) }
                .catchAndReturn(.addFavorites(item))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .search(let searchResult):
            newState.searchResult = searchResult
        case .setSearching(let isSearching):
            newState.isSearching = isSearching
        case .startChartFlow(let searchResult):
            coordinator.startChartFlow(with: searchResult)
        case .addFavorites(let item):
            if let index = newState.searchResult.firstIndex(
                where: { item.ticker == $0.ticker }
            ) {
                var newResult = newState.searchResult
                newResult.remove(at: index)
                newResult.insert(item, at: index)
                newState.searchResult = newResult
            }
        }
        return newState
    }
}

extension SearchStockReactor {
    struct State {
        var searchResult: [SearchStocksResponse] = []
        var isSearching = false
    }
    
    enum Action {
        case searchTermChangeEvent(searchTerm: String)
        case stockCellTapEvent(SearchStocksResponse)
        case likeButtonTapEvent(SearchStocksResponse)
    }
    
    enum Mutation {
        case setSearching(Bool)
        case search(searchResult: [SearchStocksResponse])
        case startChartFlow(SearchStocksResponse)
        case addFavorites(SearchStocksResponse)
    }
}
    
