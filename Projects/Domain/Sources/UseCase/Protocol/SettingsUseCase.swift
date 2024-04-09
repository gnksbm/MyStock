//
//  SettingsUseCase.swift
//  Domain
//
//  Created by gnksbm on 4/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxSwift

public protocol SettingsUseCase {
    func fetchAPIKey() -> Observable<(appKey: String, secretKey: String)>
    func saveAPIKey(
        appKey: String,
        secretKey: String
    )
}
