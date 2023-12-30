//
//  KISCheckBalanceRepository.swift
//  Domain
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol KISCheckBalanceRepository {
    var fetchResult: PublishSubject<[KISCheckBalanceResponse]> { get }
    
    func requestBalance(
        request: KISCheckBalanceRequest,
        authorization: String
    )
}
