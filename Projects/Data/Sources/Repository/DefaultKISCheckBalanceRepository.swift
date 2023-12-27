//
//  DefaultKISCheckBalanceRepository.swift
//  Data
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import Networks

import RxSwift

public final class DefaultKISCheckBalanceRepository: KISCheckBalanceRepository {
    
    private let networkService: NetworkService
    private let disposeBag = DisposeBag()
    
    public var successedFetch = PublishSubject<[KISCheckBalanceResponse]>()
    
    public func requestBalance(
        request: KISCheckBalanceRequest,
        authorization: String
    ) {
        networkService.send(
            endPoint: KISCheckBalanceEndPoint(
                investType: request.investType,
                query: request.accountRequest.toQuery,
                authorization: authorization
            )
        )
        .withUnretained(self)
        .subscribe(
            onNext: { repository, data in
                do {
                    let dto = try JSONDecoder().decode(KISCheckBalanceDTO.self, from: data)
                    repository.successedFetch.onNext(dto.toDomain)
                } catch {
                    repository.successedFetch.onError(error)
                }
            },
            onError: { print($0.localizedDescription) }
        )
        .disposed(by: disposeBag)
    }
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
}
