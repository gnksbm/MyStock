//
//  APISettingsViewModel.swift
//  SettingsFeature
//
//  Created by gnksbm on 2/13/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift

final class APISettingsViewModel: ViewModel {
    @Injected(SettingsUseCase.self) private var useCase: SettingsUseCase
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            appKey: .init(value: ""),
            secretKey: .init(value: "")
        )
        
        input.viewWillAppearEvent
            .take(1)
            .withUnretained(self)
            .subscribe(
                onNext: { vm, _ in
                    vm.useCase.fetchAPIKey()
                        .subscribe(
                            onNext: { apiKey, secretKey in
                                output.appKey.onNext(apiKey)
                                output.secretKey.onNext(secretKey)
                            }
                        )
                        .disposed(by: vm.disposeBag)
                }
            )
            .disposed(by: disposeBag)
        
        input.saveBtnTapEvent
            .withLatestFrom(input.appKeyText)
            .withLatestFrom(input.secretKeyText) { appKey, secretKey in
                (appKey, secretKey)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { vm, tuple in
                    let (appKey, secretKey) = tuple
                    vm.useCase.saveAPIKey(
                        appKey: appKey,
                        secretKey: secretKey
                    )
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension APISettingsViewModel {
    struct Input { 
        let viewWillAppearEvent: Observable<Void>
        let appKeyText: Observable<String>
        let secretKeyText: Observable<String>
        let saveBtnTapEvent: Observable<Void>
    }
    struct Output { 
        let appKey: BehaviorSubject<String>
        let secretKey: BehaviorSubject<String>
    }
}
