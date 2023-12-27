//
//  KISCheckBalanceResponse.swift
//  Domain
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

public struct KISCheckBalanceResponse {
    let tiker: String
    let name: String
    let price: String
    let amount: String
    let value: String
    let division: Division
    
    public init(
        tiker: String,
        name: String,
        price: String,
        amount: String,
        value: String,
        division: Division
    ) {
        self.tiker = tiker
        self.name = name
        self.price = price
        self.amount = amount
        self.value = value
        self.division = division
    }
}

public extension KISCheckBalanceResponse {
    enum Division {
        case cash, loan
    }
}
