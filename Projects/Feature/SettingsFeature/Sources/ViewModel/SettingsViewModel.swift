import Foundation

import Domain
import FeatureDependency

import RxSwift

public final class SettingsViewModel: ViewModel {
    private let coordinator: SettingsCoordinator
    private let disposeBag = DisposeBag()
    
    public init(coordinator: SettingsCoordinator) {
        self.coordinator = coordinator
    }
    
    public func transform(input: Input) -> Output {
        let output = Output()
        
        input.apiBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    print("tap")
                    viewModel.coordinator.pushToAPIView()
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension SettingsViewModel {
    public struct Input {
        let apiBtnTapEvent: Observable<Void>
    }
    
    public struct Output {
    }
}
