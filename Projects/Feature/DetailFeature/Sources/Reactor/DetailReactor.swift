import Foundation

import Domain
import FeatureDependency

import RxSwift
import ReactorKit

public final class DetailReactor: Reactor {
    public var initialState = State()
    
    public init() { }
}

extension DetailReactor {
    public struct State {
    }
    
    public enum Action {
    }
    
    public enum Mutation {
    }
}
