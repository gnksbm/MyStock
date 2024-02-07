import Foundation

import Domain
import FeatureDependency

import RxSwift

public final class FavoritesViewModel: ViewModel {
    private let coordinator: FavoritesCoordinator
    
    private let disposeBag = DisposeBag()
    
    public init(coordinator: FavoritesCoordinator) {
        self.coordinator = coordinator
    }
    
    public func transform(input: Input) -> Output {
        let output = Output()
        
        input.addBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.coordinator.startSearchFlow()
                }
            )
            .disposed(by: disposeBag)
        return output
    }
}

extension FavoritesViewModel {
    public struct Input {
        let addBtnTapEvent: Observable<Void>
    }
    
    public struct Output {
    }
}
