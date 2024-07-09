//
//  APISettingsViewModel.swift
//  SettingsFeature
//
//  Created by gnksbm on 2/13/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Domain
import FeatureDependency

import ReactorKit

final class APISettingsReactor: Reactor {
    private let useCase: SettingsUseCase
    private let coordinator: APISettingsCoordinator
    
    var initialState = State()
    
    struct State {
        var userInfo: KISUserInfo = .init(
            accountNum: "",
            appKey: "",
            secretKey: ""
        )
    }
    
    enum Mutation { 
        case fetchUserInfo(userInfo: KISUserInfo)
        case saveUserInfo
        case invalidInput(input: String)
    }
    
    enum Action { 
        case viewWillAppearEvent
        case saveBtnTapEvent(userInfo: KISUserInfo)
    }
    
    init(
        useCase: SettingsUseCase,
        coordinator: APISettingsCoordinator
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppearEvent:
            return useCase.fetchAPIInfo()
                .map { .fetchUserInfo(userInfo: $0) }
        case .saveBtnTapEvent(let userInfo):
            if userInfo.appKey.isEmpty {
                return .just(.invalidInput(input: "앱키"))
            } else if userInfo.secretKey.isEmpty {
                return .just(.invalidInput(input: "시크릿키"))
            } else if userInfo.accountNum.isEmpty {
                return .just(.invalidInput(input: "계좌번호"))
            } else {
                return useCase.saveAPIInfo(userInfo: userInfo)
                    .map { _ in .saveUserInfo }
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .fetchUserInfo(let userInfo):
            newState.userInfo = userInfo
        case .saveUserInfo:
            coordinator.finishFlow()
        case .invalidInput(let input):
            let title = "잘못된 입력입니다"
            coordinator.showAlert(
                title: title,
                message: "\(input)가 비었습니다"
            )
        }
        return newState
    }
}
