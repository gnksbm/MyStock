//
//  AccountWidgetProvider.swift
//  Widget
//
//  Created by gnksbm on 5/2/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import WidgetKit

import Domain

import RxSwift

struct AccountWidgetProvider: TimelineProvider {
    private let oAuthRepository: KISOAuthRepository
    private let checkBalanceRepository: KISCheckBalanceRepository
    private let disposeBag = DisposeBag()
    
    public init(
        oAuthRepository: KISOAuthRepository,
        checkBalanceRepository: KISCheckBalanceRepository
    ) {
        self.oAuthRepository = oAuthRepository
        self.checkBalanceRepository = checkBalanceRepository
    }
    
    func placeholder(in context: Context) -> AccountWidgetEntry {
        AccountWidgetEntry(
            date: Date().addingTimeInterval(1),
            balanceResponseList: []
        )
    }
    
    func getSnapshot(
        in context: Context,
        completion: @escaping (AccountWidgetEntry) -> Void
    ) {
        let entry = AccountWidgetEntry(
            date: Date(),
            balanceResponseList: []
        )
        completion(entry)
    }
    
    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<AccountWidgetEntry>) -> Void
    ) {
        guard let accountNum = UserDefaults.appGroup
            .string(forKey: "accountNum")
        else { return }
        oAuthRepository.fetchToken(
            request: .init(
                oAuthType: .access,
                investType: .reality
            )
        )
        .flatMap { oAuthToken in
            checkBalanceRepository.fetchBalance(
                request: .init(
                    investType: .reality,
                    marketType: .domestic,
                    accountNumber: accountNum
                ),
                authorization: oAuthToken.token
            )
        }
        .subscribe(
            onNext: { responses in
                let entries: [AccountWidgetEntry] = [
                    AccountWidgetEntry(
                        date: Date().addingTimeInterval(300),
                        balanceResponseList: responses
                    )
                ]
                let timeLine = Timeline(entries: entries, policy: .atEnd)
                completion(timeLine)
            }
        )
        .disposed(by: disposeBag)
    }
}
