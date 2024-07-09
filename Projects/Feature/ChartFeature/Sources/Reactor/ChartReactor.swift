import Foundation

import Domain
import FeatureDependency

import ReactorKit

final class ChartReactor: Reactor {
    private let coordinator: Coordinator
    private let useCase: ChartUseCase
    
    var initialState: State
    
    private let ticker: String
    private let marketType: MarketType
    
    struct State {
        var candleDatas: [KISChartPriceResponse] = []
        var title: String = ""
    }
    
    enum Mutation {
        case fetchResult([KISChartPriceResponse])
    }
    
    enum Action {
        case viewWillAppearEvent
    }
    
    init(
        useCase: ChartUseCase,
        title: String,
        ticker: String,
        marketType: MarketType,
        coordinator: Coordinator
    ) {
        self.useCase = useCase
        self.ticker = ticker
        self.marketType = marketType
        self.coordinator = coordinator
        self.initialState = State(title: title)
    }
    
    deinit {
        coordinator.finish()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppearEvent:
            let date = Date()
            return useCase.fetchRealtimeChart(
                period: .day,
                marketType: marketType,
                ticker: ticker,
                startDate: Date(
                    timeInterval: 86400 * -100,
                    since: date
                ).toString(dateFormat: "yyyyMMdd"),
                endDate: date.toString(dateFormat: "yyyyMMdd")
            )
            .map { responses in
                    .fetchResult(responses)
            }
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        switch mutation {
        case .fetchResult(let responses):
            newState.candleDatas = responses
        }
        return newState
    }
}
