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
    
    public func fetchAPIKey(
    ) -> Observable<(appKey: String, secretKey: String)> {
        .create { observer in
            let disposable = Disposables.create()
            let userDefaults = UserDefaults.standard
            guard let appKey = userDefaults.string(forKey: "appKey"),
            let secretKey = userDefaults.string(forKey: "secretKey")
            else {
                return disposable
            }
            observer.onNext((appKey, secretKey))
            return disposable
        }
    }
    
    public func saveAPIKey(
        appKey: String,
        secretKey: String
    ) {
        let userDefaults = UserDefaults.standard
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
