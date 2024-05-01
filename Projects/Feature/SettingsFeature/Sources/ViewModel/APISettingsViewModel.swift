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
    
    private let capturedApiKey = PublishSubject<KISUserInfo>()
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
                            onNext: { userInfo in
                                output.accountNum.onNext(userInfo.accountNum)
                                output.appKey.onNext(userInfo.appKey)
                                output.secretKey.onNext(userInfo.secretKey)
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
                onNext: { vm, userInfo in
                    let accountNum = userInfo.accountNum
                    let appKey = userInfo.appKey
                    let secretKey = userInfo.secretKey
                    if !accountNum.isEmpty &&
                        !appKey.isEmpty &&
                        !secretKey.isEmpty {
                        vm.useCase.saveAPIInfo(
                            userInfo: .init(
                                accountNum: accountNum,
                                appKey: appKey,
                                secretKey: secretKey
                            )
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
        let qrGenerateBtnEvent: Observable<KISUserInfo>
        let saveBtnTapEvent: Observable<KISUserInfo>
    }
    struct Output { 
        let accountNum: BehaviorSubject<String>
        let appKey: BehaviorSubject<String>
        let secretKey: BehaviorSubject<String>
    }
}

extension APISettingsViewModel: QRCodeReaderCoordinatorFinishDelegate {
    func capturedData(data: Data) {
        guard let apiKey = try? data.decode(type: KISUserInfo.self)
        else { return }
        capturedApiKey.onNext(apiKey)
    }
}
