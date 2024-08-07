//
//  DefaultSettingsUseCase.swift
//  Domain
//
//  Created by gnksbm on 4/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core

import RxSwift

public final class DefaultSettingsUseCase: SettingsUseCase {
    @UserDefaultsWrapper(
        key: .userInfo,
        defaultValue: KISUserInfo(
            accountNum: "",
            appKey: "",
            secretKey: ""
        )
    )
    private var userInfo: KISUserInfo
    
    public init() { }
    
    public func fetchAPIInfo() -> Observable<KISUserInfo> {
        .create { [weak self] observer in
            let disposable = Disposables.create()
            guard let self else { return disposable }
            observer.onNext(userInfo)
            observer.onCompleted()
            return disposable
        }
    }
    
    public func saveAPIInfo(userInfo: KISUserInfo) -> Observable<KISUserInfo> {
        .create { [weak self] observer in
            self?.userInfo = userInfo
            observer.onNext(userInfo)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
