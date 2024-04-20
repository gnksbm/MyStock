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
    private let coordinator: APISettingsCoordinator
    
    private let capturedApiKey = PublishSubject<APIKey>()
    private let disposeBag = DisposeBag()
    
    init(coordinator: APISettingsCoordinator) {
        self.coordinator = coordinator
    }
    
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
        
        input.qrGenerateBtnEvent
            .withUnretained(self)
            .subscribe(
                onNext: { vm, apiKey in
                    guard let data = apiKey.encode()
                    else { return }
                    vm.coordinator.presentWithImg(
                        img: .generateQRImg(data: data)
                    )
                }
            )
            .disposed(by: disposeBag)
        
        input.qrReaderBtnEvent
            .withUnretained(self)
            .subscribe(
                onNext: { vm, _ in
                    vm.coordinator.startQRCodeReaderFlow()
                }
            )
            .disposed(by: disposeBag)
        
        input.saveBtnTapEvent
            .throttle(
                .seconds(1),
                scheduler: MainScheduler.asyncInstance
            )
            .withUnretained(self)
            .subscribe(
                onNext: { vm, apiKey in
                    let appKey = apiKey.appKey
                    let secretKey = apiKey.secretKey
                    if !appKey.isEmpty && !secretKey.isEmpty {
                        vm.useCase.saveAPIKey(
                            appKey: appKey,
                            secretKey: secretKey
                        )
                    } else {
                        let title = "잘못된 입력입니다"
                        var message = ""
                        if appKey.isEmpty && secretKey.isEmpty {
                            message = "앱키와 시크릿키를 입력해주세요"
                        } else if appKey.isEmpty {
                            message = "앱키를 입력해주세요"
                        } else if secretKey.isEmpty {
                            message = "시크릿키를 입력해주세요"
                        }
                        vm.coordinator.showAlert(
                            title: title,
                            message: message
                        )
                    }
                }
            )
            .disposed(by: disposeBag)
        
        capturedApiKey
            .subscribe(
                onNext: { apiKey in
                    output.appKey.onNext(apiKey.appKey)
                    output.secretKey.onNext(apiKey.secretKey)
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension APISettingsViewModel {
    struct Input { 
        let viewWillAppearEvent: Observable<Void>
        let qrReaderBtnEvent: Observable<Void>
        let qrGenerateBtnEvent: Observable<APIKey>
        let saveBtnTapEvent: Observable<APIKey>
    }
    struct Output { 
        let appKey: BehaviorSubject<String>
        let secretKey: BehaviorSubject<String>
    }
}

extension APISettingsViewModel: QRCodeReaderCoordinatorFinishDelegate {
    func capturedData(data: Data) {
        guard let apiKey = try? data.decode(type: APIKey.self)
        else { return }
        capturedApiKey.onNext(apiKey)
    }
}
