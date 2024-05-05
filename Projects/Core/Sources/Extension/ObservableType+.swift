//
//  ObservableType+.swift
//  Core
//
//  Created by gnksbm on 5/5/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxSwift

public extension ObservableType {
    func bindSnapshot(
        to method: @escaping (Element) -> Void) -> Disposable {
            self.subscribe(
                onNext: { element in
                    method(element)
                }
            )
    }
}
