import Foundation

import Domain
import FeatureDependency

import ReactorKit

public final class FavoritesReactor: Reactor {
    public var initialState = State()
    private let coordinator: FavoritesCoordinator
    private let useCase: FavoritesUseCase
    
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
    
    public func mutate(action: Action) -> Observable<Mutation> {
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
    
    public func reduce(state: State, mutation: Mutation) -> State {
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

extension FavoritesReactor {
    public struct State {
        var favoritesStocks: [KISCurrentPriceResponse] = []
    }
    
    public enum Action {
        case viewWillAppearEvent
        case addBtnTapEvent
        case stockCellTapEvent(KISCurrentPriceResponse)
    }
    
    public enum Mutation {
        case fetchFavorites([KISCurrentPriceResponse])
        case startSearchFlow
        case startChartFlow(KISCurrentPriceResponse)
    }
}
