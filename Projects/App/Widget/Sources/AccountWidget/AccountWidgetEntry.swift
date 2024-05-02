//
//  AccountWidgetEntry.swift
//  Widget
//
//  Created by gnksbm on 5/2/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import WidgetKit

import Domain

struct AccountWidgetEntry: TimelineEntry {
    let date: Date
    let balanceResponseList: [KISCheckBalanceResponse]
}

#if DEBUG
extension AccountWidgetEntry {
    static let mock: Self = .init(
        date: .now,
        balanceResponseList: [
            KISCheckBalanceResponse(
                ticker: "035420",
                name: "NAVER",
                price: "188800",
                amount: "57",
                plAmount: "-1916478",
                fluctuationRate: "99.00000000",
                division: KISCheckBalanceResponse.Division.cash
            ),
            KISCheckBalanceResponse(
                ticker: "035420",
                name: "NAVER",
                price: "188800",
                amount: "73",
                plAmount: "-1983100",
                fluctuationRate: "-99.00000000",
                division: KISCheckBalanceResponse.Division.loan
            )
        ]
    )
}
#endif
