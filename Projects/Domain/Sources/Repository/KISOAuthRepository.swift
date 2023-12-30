//
//  KISOAuthRepository.swift
//  Domain
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol KISOAuthRepository {
    var accessToken: PublishSubject<KISOAuthToken> { get }
    var wsToken: PublishSubject<KISOAuthToken> { get }
    func requestOAuth(request: KISOAuthRequest)
}
