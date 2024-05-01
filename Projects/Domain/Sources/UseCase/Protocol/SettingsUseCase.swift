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
    func fetchAPIInfo(
    ) -> Observable<KISUserInfo>
    func saveAPIInfo(
        userInfo: KISUserInfo
    )
}
