//
//  APISettingsViewModel.swift
//  SettingsFeature
//
//  Created by gnksbm on 2/13/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import FeatureDependency

import RxSwift

final class APISettingsViewModel: ViewModel {
    func transform(input: Input) -> Output {
        let output = Output()
        return output
    }
}
extension APISettingsViewModel {
    struct Input { 
        let appKeyText: Observable<String>
        let secretKeyText: Observable<String>
        let saveBtnTapEvent: Observable<Void>
    }
    struct Output { }
}
