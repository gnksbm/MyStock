//
//  DefaultHomeUseCase.swift
//  Domain
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public final class DefaultHomeUseCase: HomeUseCase {
    private let oAuthRepository: KISOAuthRepository
    private let disposeBag = DisposeBag()
    
    let message = PublishSubject<URLSessionWebSocketTask.Message>()
    
    public init(oAuthRepository: KISOAuthRepository) {
        self.oAuthRepository = oAuthRepository
    }
    
    public func connectWS() {
        oAuthRepository.requestOAuth(
            request: .init(
                oAuthType: .webSocket,
                investType: .reality
            )
        )
    }
}
