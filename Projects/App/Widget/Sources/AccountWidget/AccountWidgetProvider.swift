//
//  AccountWidgetProvider.swift
//  Widget
//
//  Created by gnksbm on 5/2/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import WidgetKit

import Data

@available(iOS 17, *)
struct AccountWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> AccountWidgetEntry {
        AccountWidgetEntry(
            date: Date(),
            fluctuationRate: 0.0
        )
    }
    
    func getSnapshot(
        in context: Context,
        completion: @escaping (AccountWidgetEntry) -> Void
    ) {
        let entry = AccountWidgetEntry(
            date: Date(),
            fluctuationRate: 0.00
        )
        completion(entry)
    }
    
    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<AccountWidgetEntry>) -> Void
    ) {
        let entries: [AccountWidgetEntry] = [
            AccountWidgetEntry(
                date: Date().addingTimeInterval(300),
                fluctuationRate: 0.0
            )
        ]
        let timeLine = Timeline(entries: entries, policy: .atEnd)
        completion(timeLine)
    }
}
