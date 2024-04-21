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
    ) -> Observable<(accountNum: String, appKey: String, secretKey: String)> {
        .create { observer in
            let disposable = Disposables.create()
            let userDefaults = UserDefaults.standard
            guard let accountNum = userDefaults.string(forKey: "accountNum"),
                  let appKey = userDefaults.string(forKey: "appKey"),
                  let secretKey = userDefaults.string(forKey: "secretKey")
            else {
                return disposable
            }
            observer.onNext((accountNum, appKey, secretKey))
            observer.onCompleted()
            return disposable
        }
    }
    
    public func saveAPIInfo(
        accountNum: String,
        appKey: String,
        secretKey: String
    ) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(
            accountNum,
            forKey: "accountNum"
        )
        userDefaults.setValue(
            appKey,
            forKey: "appKey"
        )
        userDefaults.setValue(
            secretKey,
            forKey: "secretKey"
        )
    }
}
