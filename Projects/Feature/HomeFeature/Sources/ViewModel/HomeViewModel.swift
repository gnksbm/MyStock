import Foundation

import Domain
import FeatureDependency

import RxSwift
import RxCocoa

public final class HomeViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    public struct Input {
    }
    public struct Output {
    }
    
    public init() {
    }
    
    public func transform(input: Input) -> Output {
        return Output()
    }
}
