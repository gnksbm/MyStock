import Foundation

import Domain
import FeatureDependency

import ReactorKit

final class FavoritesReactor: Reactor {
    var initialState = State()
    private let coordinator: FavoritesCoordinator
    private let useCase: FavoritesUseCase
    
    struct State { 
        var favoritesStocks: [SearchStocksResponse] = []
    }
    
    enum Mutation { 
        case fetchFavorites([SearchStocksResponse])
        case startSearchFlow
        case startChartFlow(SearchStocksResponse)
    }
    
    enum Action { 
        case viewWillAppearEvent
        case addBtnTapEvent
        case stockCellTapEvent(SearchStocksResponse)
    }
    
    init(
        useCase: FavoritesUseCase,
        coordinator: FavoritesCoordinator
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator.finish()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppearEvent:
            useCase.fetchFavorites()
                .map { fetchResult in
                        .fetchFavorites(fetchResult)
                }
        case .addBtnTapEvent:
                .just(.startSearchFlow)
        case .stockCellTapEvent(let stockInfo):
                .just(.startChartFlow(stockInfo))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .fetchFavorites(let fetchResult):
            newState.favoritesStocks = fetchResult
        case .startSearchFlow:
            coordinator.startSearchFlow()
        case .startChartFlow(let stockInfo):
            coordinator.startChartFlow(with: stockInfo)
        }
        return newState
    }
}
