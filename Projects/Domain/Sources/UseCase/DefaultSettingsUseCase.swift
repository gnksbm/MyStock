//
//  DefaultSettingsUseCase.swift
//  Domain
//
//  Created by gnksbm on 4/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxSwift

public final class DefaultSettingsUseCase: SettingsUseCase {
    public init() { }
    
    public func fetchAPIInfo(
    ) -> Observable<KISUserInfo> {
        .create { observer in
            let disposable = Disposables.create()
            let userDefaults = UserDefaults.appGroup
            guard let accountNum = userDefaults.string(forKey: "accountNum"),
                  let appKey = userDefaults.string(forKey: "appKey"),
                  let secretKey = userDefaults.string(forKey: "secretKey")
            else {
                return disposable
            }
            observer.onNext(
                .init(
                    accountNum: accountNum,
                    appKey: appKey,
                    secretKey: secretKey
                )
            )
            observer.onCompleted()
            return disposable
        }
    }
    
    public func saveAPIInfo(
        userInfo: KISUserInfo
    ) {
        let userDefaults = UserDefaults.appGroup
        userDefaults.setValue(
            userInfo.accountNum,
            forKey: "accountNum"
        )
        userDefaults.setValue(
            userInfo.appKey,
            forKey: "appKey"
        )
        userDefaults.setValue(
            userInfo.secretKey,
            forKey: "secretKey"
        )
    }
}
