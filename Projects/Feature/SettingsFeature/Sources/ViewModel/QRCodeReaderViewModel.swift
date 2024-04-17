//
//  QRCodeReaderViewModel.swift
//  SettingsFeature
//
//  Created by gnksbm on 4/10/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import FeatureDependency

import RxSwift

final class QRCodeReaderViewModel: ViewModel {
    func transform(input: Input) -> Output {
        let output = Output()
        return output
    }
}

extension QRCodeReaderViewModel {
    struct Input {
        let capturedData: Observable<Data>
    }
    
    struct Output {
    }
}
