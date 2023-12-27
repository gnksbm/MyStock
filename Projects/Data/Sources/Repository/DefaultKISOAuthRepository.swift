//
//  DefaultKISOAuthRepository.swift
//  Data
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import Networks

import RxSwift

public final class DefaultKISOAuthRepository: KISOAuthRepository {
    private let networkService: NetworkService
    private let disposeBag = DisposeBag()
    
    public var successedFetch = PublishSubject<String>()
    
    public func requestOAuth(request: KISOAuthRequest) {
        networkService.send(endPoint: KISOAuthEndPoint(request: request))
            .withUnretained(self)
            .subscribe(
                onNext: { repository, data in
                    let decoder = JSONDecoder()
                    switch request.oAuthType {
                    case .access:
                        do {
                            let token = try decoder.decode(
                                KISAccessOAuthDTO.self,
                                from: data
                            ).accessToken
                            repository.successedFetch.onNext(token)
                        } catch {
                            repository.successedFetch.onError(error)
                        }
                    case .webSocket:
                        do {
                            let token = try decoder.decode(
                                KisWebSocketOAuthDTO.self,
                                from: data
                            ).approvalKey
                            repository.successedFetch.onNext(token)
                        } catch {
                            repository.successedFetch.onError(error)
                        }
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
}
