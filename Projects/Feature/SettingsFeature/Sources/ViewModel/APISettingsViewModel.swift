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
    private let useCase: SettingsUseCase
    private let coordinator: APISettingsCoordinator
    
    private let capturedApiKey = PublishSubject<APIKey>()
    private let disposeBag = DisposeBag()
    
    init(
        useCase: SettingsUseCase,
        coordinator: APISettingsCoordinator
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            accountNum: .init(value: ""),
            appKey: .init(value: ""),
            secretKey: .init(value: "")
        )
        
        input.viewWillAppearEvent
            .take(1)
            .withUnretained(self)
            .subscribe(
                onNext: { vm, _ in
                    vm.useCase.fetchAPIInfo()
                        .subscribe(
                            onNext: { (accountNum, appKey, secretKey) in
                                output.accountNum.onNext(accountNum)
                                output.appKey.onNext(appKey)
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
                onNext: { vm, tuple in
                    let (accountNum, apiKey) = tuple
                    let appKey = apiKey.appKey
                    let secretKey = apiKey.secretKey
                    if !accountNum.isEmpty &&
                        !appKey.isEmpty &&
                        !secretKey.isEmpty {
                        vm.useCase.saveAPIInfo(
                            accountNum: accountNum,
                            appKey: appKey,
                            secretKey: secretKey
                        )
                        vm.coordinator.finishFlow()
                    } else {
                        let title = "잘못된 입력입니다"
                        var message = ""
                        if accountNum.isEmpty {
                            message = "계좌번호를 입력해주세요"
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
        let saveBtnTapEvent: Observable<(String, APIKey)>
    }
    struct Output { 
        let accountNum: BehaviorSubject<String>
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
