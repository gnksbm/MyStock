//
//  AccountWidgetProvider.swift
//  Widget
//
//  Created by gnksbm on 5/2/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import WidgetKit

import Core
import Domain
import Data
import Networks

import RxSwift

struct AccountWidgetProvider: TimelineProvider {
    @Injected private var oAuthRepository: KISOAuthRepository
    @Injected private var checkBalanceRepository: KISBalanceRepository
    private let disposeBag = DisposeBag()
    
    public init() {
        DIContainer.register(
            type: KISOAuthRepository.self,
            DefaultKISOAuthRepository()
        )
        DIContainer.register(
            type: KISBalanceRepository.self,
            DefaultKISBalanceRepository()
        )
        DIContainer.register(
            type: NetworkService.self,
            DefaultNetworkService()
        )
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
            onNext: { (_, responses) in
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
