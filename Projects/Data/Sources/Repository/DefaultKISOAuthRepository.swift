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

    public init() { }
    
    deinit {
        #if DEBUG
        print(
            String(describing: self),
            ": deinit"
        )
        #endif
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
            .map { data in
                var dto: KISOAuthDTO
                do {
                    switch request.oAuthType {
                    case .webSocket:
                        dto = try data.decode(type: KISWebSocketOAuthDTO.self)
                    case .access:
                        dto = try data.decode(type: KISAccessOAuthDTO.self)
                    }
                } catch {
                    throw error
                }
                return dto.toDomain
            }
            .map { result in
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
}
