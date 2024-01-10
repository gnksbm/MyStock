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
    
    private func handleToken(
        token: KISOAuthToken,
        request: KISOAuthRequest
    ) {
        guard let data = token.expireDate.encode() else { return }
        let tokenType = request.oAuthType.rawValue
        let userDefault = UserDefaults.standard
        userDefault.setValue(
            token.token,
            forKey: "\(tokenType)Token"
        )
        userDefault.setValue(
            data,
            forKey: "\(tokenType)Date"
        )
    }
    
    public func requestOAuth(request: KISOAuthRequest) {
        if checkUserDefault(request: request) {
            return
        }
        let endPoint = KISOAuthEndPoint(
            investType: request.investType,
            oAuthType: request.oAuthType
        )
        networkService.request(
            endPoint: endPoint
        )
        .withUnretained(self)
        .subscribe(
            onNext: { repository, data in
                switch request.oAuthType {
                case .access:
                    do {
                        let accessToken = try data.decode(
                            type: KISAccessOAuthDTO.self
                        ).toDomain
                        repository.handleToken(
                            token: accessToken,
                            request: request
                        )
                        repository.accessToken.onNext(accessToken)
                    } catch {
                        repository.accessToken.onError(error)
                    }
                case .webSocket:
                    do {
                        let approvalKey = try data.decode(
                            type: KISWebSocketOAuthDTO.self
                        ).approvalKey
                        let oAuthToken = KISOAuthToken(
                            token: approvalKey,
                            expireDate: Date(
                                timeInterval: 86400,
                                since: .now
                            )
                        )
                        repository.handleToken(
                            token: oAuthToken,
                            request: request
                        )
                        repository.wsToken.onNext(oAuthToken)
                    } catch {
                        repository.wsToken.onError(error)
                    }
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
    
    private func checkUserDefault(request: KISOAuthRequest) -> Bool {
        if request.oAuthType == .access {
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
                print("\(tokenType) UserDefaultToken")
                return true
            }
            return false
        } else {
            return false
        }
    }
}
