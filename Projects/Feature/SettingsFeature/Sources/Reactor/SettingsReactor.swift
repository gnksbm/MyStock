import Foundation

import Domain
import FeatureDependency

import ReactorKit

final class SettingsReactor: Reactor {
    private let coordinator: SettingsCoordinator
    
    var initialState = State()
    
    struct State { }
    
    enum Mutation { 
        case startApiSettingFlow
    }
    
    enum Action { 
        case apiBtnTapEvent
    }
    
    init(coordinator: SettingsCoordinator) {
        self.coordinator = coordinator
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .apiBtnTapEvent:
                .just(.startApiSettingFlow)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        let newState = state
        switch mutation {
        case .startApiSettingFlow:
            coordinator.startApiSettingFlow()
        }
        return newState
    }
}
