import Foundation

import Domain
import FeatureDependency

import ReactorKit

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
        var collateralRatioMsg: String = ""
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
        case failToLogin
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            useCase.fetchBalance()
                .map { .fetchedBalanceInfo($0) }
                .catchAndReturn(.failToLogin)
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
        case .fetchedBalanceInfo(let (ratio, balances)):
            newState.balanceList = balances
            newState.collateralRatioMsg = "담보 유지 비율: \(String(Int(ratio)))%"
        case .startChartFlow(let index):
            coordinator.startChartFlow(with: newState.balanceList[index])
        case .startSearchFlow:
            coordinator.startSearchStocksFlow()
        case .failToLogin:
            newState.collateralRatioMsg = "계좌 정보를 확인하려면 로그인 해주세요"
            coordinator.showAlert(
                title: "로그인에 실패했습니다.",
                message: "로그인 정보를 수정해주세요",
                alertAction: [
                    .init(
                        title: "설정하러 가기",
                        style: .destructive,
                        handler: { [weak self] _ in
                            self?.coordinator.startApiSettingsFlow()
                        }
                    ),
                    .init(
                        title: "확인",
                        style: .cancel
                    )
                ]
            )
        }
        return newState
    }
}
