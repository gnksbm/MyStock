//
//  AccountWidget.swift
//  Widget
//
//  Created by gnksbm on 5/2/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import WidgetKit
import SwiftUI

import Data
import Networks

struct AccountWidget: Widget {
    let kind: String = "AccountWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: AccountWidgetProvider()
        ) { entry in
            AccountWidgetEntryView(entry: entry)
                .widgetBackground()
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("나의 오늘 수익률")
        .description("계좌 수익률을 빠르게 확인하세요")
    }
}
