//
//  KISCheckBalanceResponse.swift
//  Domain
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import UIKit

public struct KISCheckBalanceResponse: Hashable {
    public let ticker: String
    public let name: String
    public let price: String
    public let amount: String
    public let plAmount: String
    public let fluctuationRate: String
    public let division: Division
    
    public var value: String {
        guard let price = Int(price),
              let amount = Int(amount)
        else { return "" }
        return String(price * amount)
    }
    
    public init(
        ticker: String,
        name: String,
        price: String,
        amount: String,
        plAmount: String,
        fluctuationRate: String,
        division: Division
    ) {
        self.ticker = ticker
        self.name = name
        self.price = price
        self.amount = amount
        self.plAmount = plAmount
        self.fluctuationRate = fluctuationRate
        self.division = division
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.ticker == rhs.ticker
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ticker.hashValue)
    }
}

public extension KISCheckBalanceResponse {
    var textColor: UIColor {
        guard let rate = Double(fluctuationRate)
        else { return .gray }
        if rate == 0 {
            return .black
        } else if rate > 0 {
            return .green
        } else {
            return .red
        }
    }
}

public extension Array<KISCheckBalanceResponse> {
    var combineSameTiker: Self {
        var amountDic = [String: Int]()
        var plAmountDic = [String: Int]()
        forEach { respense in
            guard let amount = Int(respense.amount),
                  let plAmount = Int(respense.plAmount)
            else { return }
            amountDic[respense.ticker, default: 0] += amount
            plAmountDic[respense.ticker, default: 0] += plAmount
        }
        let result: Self = compactMap {
            guard let amount = amountDic[$0.ticker],
                  let plAmount = plAmountDic[$0.ticker]
            else { return nil }
            return Element(
                ticker: $0.ticker,
                name: $0.name,
                price: $0.price,
                amount: String(amount),
                plAmount: String(plAmount),
                fluctuationRate: $0.fluctuationRate,
                division: $0.division
            )
        }
        return Array(Set(result))
    }
}

public extension KISCheckBalanceResponse {
    enum Division {
        case cash, loan
    }
}
