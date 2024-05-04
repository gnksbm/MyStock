import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift
import RxRelay

public final class BalanceViewModel: ViewModel {
    private let useCase: BalanceUseCase
    
    private let disposeBag = DisposeBag()
    
    let coordinator: BalanceCoordinator
    
    public init(
        useCase: BalanceUseCase,
        coordinator: BalanceCoordinator
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(
            balanceList: .init(value: []),
            collateralRatio: .init()
        )
        
        input.viewWillAppear
            .throttle(
                .seconds(10),
                scheduler: MainScheduler.asyncInstance
            )
            .withUnretained(self)
            .flatMap { vm, _ in
                vm.useCase.fetchBalance()
            }
            .subscribe(
                onNext: { collateralRatio, responses in
                    output.collateralRatio.onNext(collateralRatio)
                    output.balanceList.accept(responses)
                }
            )
            .disposed(by: disposeBag)
        
        input.stockCellTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, row in
                    viewModel.coordinator.startChartFlow(
                        with: output.balanceList.value[row]
                    )
                }
            )
            .disposed(by: disposeBag)
        
        input.searchBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.coordinator.startSearchStocksFlow()
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension BalanceViewModel {
    public struct Input {
        let viewWillAppear: Observable<Void>
        let stockCellTapEvent: Observable<Int>
        let searchBtnTapEvent: Observable<Void>
    }
    
    public struct Output {
        let balanceList: BehaviorRelay<[KISCheckBalanceResponse]>
        let collateralRatio: PublishSubject<Double>
    }
}
