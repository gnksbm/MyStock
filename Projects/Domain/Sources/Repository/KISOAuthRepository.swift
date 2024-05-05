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
    func fetchToken(request: KISOAuthRequest) -> Observable<KISOAuthToken>
}
