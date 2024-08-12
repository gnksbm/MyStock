import Foundation

import Domain
import FeatureDependency

import RxSwift
import ReactorKit

public final class SummaryReactor: Reactor {
    private let coordinator: SummaryCoordinator
    private let favoriteUseCase: FavoritesUseCase
    private let summaryUseCase: SummaryUseCase
    
    public var initialState = State()
    
    public init(
        coordinator: SummaryCoordinator,
        favoriteUseCase: FavoritesUseCase,
        summaryUseCase: SummaryUseCase
    ) {
        self.coordinator = coordinator
        self.summaryUseCase = summaryUseCase
        self.favoriteUseCase = favoriteUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            Observable.merge(
                favoriteUseCase.fetchFavorites()
                    .map { .fetchFavoriteItems($0) },
                summaryUseCase.fetchTopVolumeItems()
                    .map { .fetchVolumeItems($0) },
                summaryUseCase.fetchTopMarketCapItems()
                    .map { .fetchMarketCapItems($0) }
            )
        case .itemSelected(let ticker):
            Observable.just(.startDetailFlow(ticker: ticker))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .fetchFavoriteItems(let items):
            newState.favoriteItems = items
        case .fetchVolumeItems(let items):
            newState.topVolumeItems = items
        case .fetchMarketCapItems(let items):
            newState.topMarketCapItems = items
        case .startDetailFlow(let ticker):
            coordinator.startDetailFlow(ticker: ticker)
        }
        return newState
    }
}

extension SummaryReactor {
    public struct State { 
        var favoriteItems: [KISCurrentPriceResponse] = []
        var topVolumeItems: [KISTopRankResponse] = []
        var topMarketCapItems: [KISTopRankResponse] = []
    }
    
    public enum Action {
        case viewWillAppear
        case itemSelected(ticker: String)
    }
    
    public enum Mutation {
        case fetchFavoriteItems([KISCurrentPriceResponse])
        case fetchVolumeItems([KISTopRankResponse])
        case fetchMarketCapItems([KISTopRankResponse])
        case startDetailFlow(ticker: String)
    }
}
