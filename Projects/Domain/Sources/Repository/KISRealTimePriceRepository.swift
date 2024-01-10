//
//  KISRealTimePriceRepository.swift
//  Domain
//
//  Created by gnksbm on 2024/01/04.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import RxSwift

public protocol KISRealTimePriceRepository {
    var price: PublishSubject<String> { get }
    
    func requestData(
        request: KISRealTimePriceRequest
    )
    
    func disconnectSocket()
}
