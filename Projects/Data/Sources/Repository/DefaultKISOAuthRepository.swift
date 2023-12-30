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
    
    public let accessToken = PublishSubject<KISOAuthToken>()
    public let wsToken = PublishSubject<KISOAuthToken>()
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func requestOAuth(request: KISOAuthRequest) {
        if checkUserDefault(request: request) {
            return
        }
        networkService.request(
            endPoint: KISOAuthEndPoint(
                investType: request.investType,
                oAuthType: request.oAuthType
            )
        )
        .withUnretained(self)
        .subscribe(
            onNext: { repository, data in
                do {
                    let response = try data.decode(
                        type: KISAccessOAuthDTO.self
                    ).toDomain
                    switch request.oAuthType {
                    case .access:
                        repository.accessToken.onNext(response)
                    case .webSocket:
                        repository.wsToken.onNext(
                            .init(
                                token: response.token,
                                expireDate: Date.now
                            )
                        )
                    }
                    let expireDate = response.expireDate
                    guard let data = expireDate.encode()
                    else { return }
                    let tokenType = request.oAuthType.rawValue
                    let userDefault = UserDefaults.standard
                    userDefault.setValue(
                        response.token,
                        forKey: "\(tokenType)Token"
                    )
                    userDefault.setValue(
                        data,
                        forKey: "\(tokenType)Date"
                    )
                    print("FetchToken: \(expireDate.distance(to: .now))")
                } catch {
                    repository.accessToken.onError(error)
                }
            },
            onError: { print($0.localizedDescription) }
        )
        .disposed(by: disposeBag)
    }
    
    private func checkUserDefault(request: KISOAuthRequest) -> Bool {
        let tokenType = request.oAuthType.rawValue
        let userDefault = UserDefaults.standard
        if let token = userDefault.string(forKey: "\(tokenType)Token"),
           let data = userDefault.data(forKey: "\(tokenType)Date"),
           let date = try? data.decode(type: Date.self),
           date.distance(to: .now) < 0 {
            switch request.oAuthType {
            case .access:
                accessToken.onNext(.init(token: token, expireDate: date))
            case .webSocket:
                wsToken.onNext(.init(token: token, expireDate: date))
            }
            print("\(tokenType) UserDefaultToken: \(date.distance(to: .now))")
            return true
        }
        return false
    }
}
