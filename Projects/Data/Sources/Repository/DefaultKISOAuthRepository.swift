//
//  DefaultKISOAuthRepository.swift
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

public final class DefaultKISOAuthRepository: KISOAuthRepository {
    @Injected(NetworkService.self)
    private var networkService: NetworkService

    private let disposeBag = DisposeBag()
    
    public let accessToken = PublishSubject<KISOAuthToken>()
    public let wsToken = PublishSubject<KISOAuthToken>()
    
    public init() { }
    
    deinit {
        #if DEBUG
        print(
            String(describing: self),
            ": deinit"
        )
        #endif
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
    
    public func fetchToken(
        request: KISOAuthRequest
    ) -> Observable<KISOAuthToken> {
        let tokenType = request.oAuthType.rawValue
        let userDefault = UserDefaults.appGroup
        if let token = userDefault.string(forKey: "\(tokenType)Token"),
           let data = userDefault.data(forKey: "\(tokenType)Date"),
           let date = try? data.decode(type: Date.self),
           date.distance(to: .now) < 0 {
            return .just(
                .init(
                    token: token,
                    expireDate: date
                )
            )
        } else {
            let endPoint = KISOAuthEndPoint(
                investType: request.investType,
                oAuthType: request.oAuthType
            )
            return networkService.request(
                endPoint: endPoint
            )
            .decode(
                type: KISAccessOAuthDTO.self,
                decoder: JSONDecoder()
            )
            .map {
                let result = $0.toDomain
                userDefault.setValue(
                    result.token,
                    forKey: "\(tokenType)Token"
                )
                if let data = result.expireDate.encode() {
                    userDefault.setValue(
                        data,
                        forKey: "\(tokenType)Date"
                    )
                }
                return result
            }
        }
    }
    
    private func handleToken(
        token: KISOAuthToken,
        request: KISOAuthRequest
    ) {
        guard let data = token.expireDate.encode() else { return }
        let tokenType = request.oAuthType.rawValue
        let userDefault = UserDefaults.appGroup
        userDefault.setValue(
            token.token,
            forKey: "\(tokenType)Token"
        )
        userDefault.setValue(
            data,
            forKey: "\(tokenType)Date"
        )
    }
    
    private func checkUserDefault(request: KISOAuthRequest) -> Bool {
        if request.oAuthType == .access {
            let tokenType = request.oAuthType.rawValue
            let userDefault = UserDefaults.appGroup
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
                return true
            }
            return false
        } else {
            return false
        }
    }
}
