//
//  KISCheckBalanceResponse.swift
//  Domain
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import UIKit

public struct KISCheckBalanceResponse: Hashable, LogoNecessary {
    public var image: UIImage?
    public let ticker: String
    public let name: String
    public let price: String
    public let amount: String
    public let plAmount: String
    public let fluctuationRate: String
    public let division: Division
    public let marketType: MarketType
    
    public init(
        ticker: String,
        name: String,
        price: String,
        amount: String,
        plAmount: String,
        fluctuationRate: String,
        division: Division,
        marketType: MarketType
    ) {
        self.ticker = ticker
        self.name = name
        self.price = price
        self.amount = amount
        self.plAmount = plAmount
        self.fluctuationRate = fluctuationRate
        self.division = division
        self.marketType = marketType
    }
}

public extension KISCheckBalanceResponse {
    var value: String {
        guard let price = Int(price),
              let amount = Int(amount)
        else { return "" }
        return String(price * amount)
    }
    
    var rateToDoubleDigits: String {
        guard let rateDouble = Double(fluctuationRate)
        else { return fluctuationRate }
        let result = String(format: "%.2f", rateDouble)
        return result
    }
}

public extension Array<KISCheckBalanceResponse> {
    var combineSameTiker: Self {
        var dic = [String: Element]()
        forEach { response in
            if let oldValue = dic[response.name] {
                guard let oldAmount = Int(oldValue.amount),
                      let nextAmount = Int(response.amount),
                      let oldPlAmount = Int(oldValue.plAmount),
                      let nextPlAmount = Int(response.plAmount)
                else { return }
                dic[response.name] = .init(
                    ticker: oldValue.ticker,
                    name: oldValue.name,
                    price: oldValue.price,
                    amount: String(oldAmount + nextAmount),
                    plAmount: String(oldPlAmount + nextPlAmount),
                    fluctuationRate: oldValue.fluctuationRate,
                    division: oldValue.division,
                    marketType: oldValue.marketType
                )
            } else {
                dic[response.name] = response
            }
        }
        return dic.map { $0.value }
    }
}

public extension KISCheckBalanceResponse {
    enum Division {
        case cash, loan
    }
}
