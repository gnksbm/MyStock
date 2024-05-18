import Foundation

import Core
import Domain
import FeatureDependency

import ReactorKit
import RxSwift
import RxRelay

final class BalanceReactor: Reactor {
    private let useCase: BalanceUseCase
    private let coordinator: BalanceCoordinator
    let initialState = State()
    
    init(
        useCase: BalanceUseCase,
        coordinator: BalanceCoordinator
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    struct State {
        var balanceList: [KISCheckBalanceResponse] = []
        var collateralRatio: Double = 0
    }
    
    enum Action {
        case viewWillAppear
        case stockCellTapEvent(index: Int)
        case searchBtnTapEvent
    }
    
    enum Mutation {
        case fetchedBalanceInfo((Double, [KISCheckBalanceResponse]))
        case startChartFlow(index: Int)
        case startSearchFlow
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            useCase.fetchBalance()
                .map { tuple in
                        .fetchedBalanceInfo(tuple)
                }
        case .stockCellTapEvent(let index):
                .just(.startChartFlow(index: index))
        case .searchBtnTapEvent:
                .just(.startSearchFlow)
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        switch mutation {
        case .fetchedBalanceInfo(let (collateralRatio, balances)):
            newState.balanceList = balances
            newState.collateralRatio = collateralRatio
        case .startChartFlow(let index):
            coordinator.startChartFlow(with: newState.balanceList[index])
        case .startSearchFlow:
            coordinator.startSearchStocksFlow()
        }
        return newState
    }
}
