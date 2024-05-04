import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift
import RxCocoa

public final class FavoritesViewModel: ViewModel {
    private let coordinator: FavoritesCoordinator
    private let useCase: FavoritesUseCase
    
    private let disposeBag = DisposeBag()
    
    public init(
        useCase: FavoritesUseCase,
        coordinator: FavoritesCoordinator
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator.finish()
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(
            favoritesStocks: .init()
        )
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .flatMap { vm, _ in
                vm.useCase.fetchFavorites()
            }
            .bind(to: output.favoritesStocks)
            .disposed(by: disposeBag)
        
        input.addBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.coordinator.startSearchFlow()
                }
            )
            .disposed(by: disposeBag)
        
        input.stockCellTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, response in
                    viewModel.coordinator.startChartFlow(
                        with: response
                    )
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension FavoritesViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
        let addBtnTapEvent: Observable<Void>
        let stockCellTapEvent: Observable<SearchStocksResponse>
    }
    
    public struct Output {
        let favoritesStocks: PublishSubject<[SearchStocksResponse]>
    }
}
