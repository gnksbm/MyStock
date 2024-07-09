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
    
    struct State { 
        var searchResult: [SearchStocksResponse] = []
        var isSearching = false
    }
    
    enum Action {
        case searchTermChangeEvent(searchTerm: String)
        case stockCellTapEvent(SearchStocksResponse)
    }
    
    enum Mutation {
        case setSearching(Bool)
        case search(searchResult: [SearchStocksResponse])
        case startChartFlow(SearchStocksResponse)
        case addFavorites
    }
    
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
            switch searchFlow {
            case .chart:
                return .just(.startChartFlow(searchResult))
            case .stockInfo:
                return useCase.addFavorites(ticker: searchResult.ticker)
                    .map { _ in .addFavorites }
            }
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
        case .addFavorites:
            coordinator.updateFavoritesFinished()
        }
        return newState
    }
}
