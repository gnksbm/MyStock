import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift
import RxRelay

public final class HomeViewModel: ViewModel {
    private let useCase: HomeUseCase
    
    private let disposeBag = DisposeBag()
    
    let coordinator: HomeCoordinator
    
    public init(
        useCase: HomeUseCase,
        coordinator: HomeCoordinator
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
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.checkAccount(
                        accountNumber: .accountNumber
                    )
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
        
        useCase.balanceInfo
            .bind(to: output.balanceList)
            .disposed(by: disposeBag)
        
        useCase.collateralRatio
            .bind(to: output.collateralRatio)
            .disposed(by: disposeBag)
        return output
    }
}

extension HomeViewModel {
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
