import Foundation

import Domain
import FeatureDependency

import RxSwift
import ReactorKit

public final class SummaryReactor: Reactor {
    private var coordinator: SummaryCoordinator
    private var useCase: SummaryUseCase
    
    public var initialState = State()
    
    public init(
        coordinator: SummaryCoordinator,
        useCase: SummaryUseCase
    ) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            Observable.merge(
                useCase.fetchTopVolumeItems()
                    .map { .fetchVolumeItems($0) },
                useCase.fetchTopMarketCapItems()
                    .map { .fetchMarketCapItems($0) }
            )
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .fetchVolumeItems(let items):
            newState.topVolumeItems = items
        case .fetchMarketCapItems(let items):
            newState.topMarketCapItems = items
        }
        return newState
    }
}

extension SummaryReactor {
    public struct State { 
        var topVolumeItems: [KISTopRankResponse] = []
        var topMarketCapItems: [KISTopRankResponse] = []
    }
    
    public enum Action {
        case viewWillAppear
    }
    
    public enum Mutation {
        case fetchVolumeItems([KISTopRankResponse])
        case fetchMarketCapItems([KISTopRankResponse])
    }
}
