//
//  DefaultKISCheckBalanceRepository.swift
//  Data
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain
import Networks

import RxSwift

public final class DefaultKISCheckBalanceRepository: KISCheckBalanceRepository {
    @Injected(NetworkService.self)
    private var networkService: NetworkService

    private let disposeBag = DisposeBag()
    
    public var fetchResult = PublishSubject<[KISCheckBalanceResponse]>()
    public var collateralRatio = PublishSubject<Double>()
    
    public init() { }

    deinit {
        #if DEBUG
        print(
            String(describing: self),
            ": deinit"
        )
        #endif
    }
    
    public func requestBalance(
        request: KISCheckBalanceRequest,
        authorization: String
    ) {
        networkService.request(
            endPoint: KISCheckBalanceEndPoint(
                investType: request.investType,
                query: request.toQuery,
                authorization: authorization
            )
        )
        .withUnretained(self)
        .subscribe(
            onNext: { repository, data in
                do {
                    let dto = try data.decode(type: KISCheckBalanceDTO.self)
                    repository.fetchResult.onNext(dto.toDomain)
                    repository.collateralRatio.onNext(dto.collateralRatio)
                } catch {
                    repository.fetchResult.onError(error)
                }
            },
            onError: {
                print(
                    "\(String(describing: self)): \($0.localizedDescription)"
                )
            }
        )
        .disposed(by: disposeBag)
    }
    
    public func fetchBalance(
        request: KISCheckBalanceRequest,
        authorization: String
    ) -> Observable<(collateralRatio: Double, [KISCheckBalanceResponse])> {
        networkService.request(
            endPoint: KISCheckBalanceEndPoint(
                investType: request.investType,
                query: request.toQuery,
                authorization: authorization
            )
        )
        .decode(
            type: KISCheckBalanceDTO.self,
            decoder: JSONDecoder()
        )
        .map { ($0.collateralRatio, $0.toDomain) }
    }
}
