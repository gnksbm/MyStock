import Foundation

import Domain
import FeatureDependency

import RxSwift
import ReactorKit

public final class DetailReactor: Reactor {
    private let useCase: DetailUseCase
    private let coordinator: DetailCoordinator
    private let ticker: String
    
    public var initialState = State()
    
    public init(
        ticker: String,
        coordinator: DetailCoordinator,
        useCase: DetailUseCase
    ) {
        self.ticker = ticker
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppearEvent:
            useCase.fetchDetailItem(ticker: ticker)
                .map { .fetchedInfo($0) }
        case .chartTapEvent:
                .just(.startChartFlow)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .fetchedInfo(let response):
            newState.dailyPriceInfo = response
        case .startChartFlow:
            if let title = newState.dailyPriceInfo?.name {
                coordinator.startChartFlow(title: title, ticker: ticker)
            }
        }
        return newState
    }
}

extension DetailReactor {
    public struct State {
        var dailyPriceInfo: KISDailyChartPriceResponse?
    }
    
    public enum Action {
        case viewWillAppearEvent
        case chartTapEvent
    }
    
    public enum Mutation {
        case fetchedInfo(KISDailyChartPriceResponse)
        case startChartFlow
    }
}
