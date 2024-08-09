import Foundation

import Domain
import FeatureDependency

import RxSwift
import ReactorKit

public final class DetailReactor: Reactor {
    private let useCase: DetailUseCase
    private let ticker: String
    
    public var initialState = State()
    
    public init(
        ticker: String,
        useCase: DetailUseCase
    ) {
        self.ticker = ticker
        self.useCase = useCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppearEvent:
            useCase.fetchDetailItem(ticker: ticker)
                .map { .fetchedInfo($0) }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .fetchedInfo(let response):
            newState.dailyPriceInfo = response
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
    }
    
    public enum Mutation {
        case fetchedInfo(KISDailyChartPriceResponse)
    }
}
