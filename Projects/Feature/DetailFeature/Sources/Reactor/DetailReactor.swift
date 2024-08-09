import Foundation

import Domain
import FeatureDependency

import RxSwift
import ReactorKit

public final class DetailReactor: Reactor {
    private let ticker: String
    
    public var initialState = State()
    
    public init(ticker: String) {
        self.ticker = ticker
    }
}

extension DetailReactor {
    public struct State {
    }
    
    public enum Action {
    }
    
    public enum Mutation {
    }
}
