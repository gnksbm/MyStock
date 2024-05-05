import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift
import RxRelay

final class ChartViewModel: ViewModel {
    private let coordinator: Coordinator
    private let useCase: ChartUseCase
    
    let title: String
    private let ticker: String
    private let marketType: MarketType
    
    private let disposeBag = DisposeBag()
    
    init(
        useCase: ChartUseCase,
        title: String,
        ticker: String,
        marketType: MarketType,
        coordinator: Coordinator
    ) {
        self.useCase = useCase
        self.title = title
        self.ticker = ticker
        self.marketType = marketType
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator.finish()
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            candleList: .init()
        )
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { vm, _ in
                let date = Date()
                return vm.useCase.fetchRealtimeChart(
                    period: .day,
                    marketType: vm.marketType,
                    ticker: vm.ticker,
                    startDate: Date(
                        timeInterval: 86400 * -100,
                        since: date
                    ).toString(dateFormat: "yyyyMMdd"),
                    endDate: date.toString(dateFormat: "yyyyMMdd")
                )
            }
            .distinctUntilChanged()
            .subscribe(
                onNext: { response in
                    output.candleList.onNext(response)
                }
            )
            .disposed(by: disposeBag)
        
        input.viewWillDisappear
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.disconnectRealTimePrice()
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
    
}

extension ChartViewModel {
    struct Input {
        let viewWillAppear: Observable<Void>
        let viewWillDisappear: Observable<Void>
    }
    
    struct Output {
        let candleList: PublishSubject<[KISChartPriceResponse]>
    }
}
