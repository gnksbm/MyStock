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
    private let coordinator: QRCodeReaderCoordinator
    private let disposeBag = DisposeBag()
    
    init(coordinator: QRCodeReaderCoordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator.finish()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        input.capturedData
            .withUnretained(self)
            .subscribe { vm, data in
                vm.coordinator.finishWithData(data: data)
            }
            .disposed(by: disposeBag)
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
