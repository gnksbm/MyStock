import Foundation

import Domain
import FeatureDependency

import RxSwift
import ReactorKit

public final class SummaryReactor: Reactor {
    private var coordinator: SummaryCoordinator
    public var initialState = State()
    
    private let disposeBag = DisposeBag()
    
    public init(coordinator: SummaryCoordinator) {
        self.coordinator = coordinator
    }
}

extension SummaryReactor {
    public struct State { 
        let topVolumeItems: [KISTopVolumeResponse] = []
    }
    
    public enum Action { 
        case viewWillAppear
    }
}
