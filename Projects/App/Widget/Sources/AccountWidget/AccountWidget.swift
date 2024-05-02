//
//  AccountWidget.swift
//  Widget
//
//  Created by gnksbm on 5/2/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import WidgetKit
import SwiftUI

@available(iOS 17, *)
struct AccountWidget: Widget {
    let kind: String = "Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: AccountWidgetProvider()
        ) { entry in
            WidgetEntryView(entry: entry)
                .containerBackground(
                    .fill.tertiary,
                    for: .widget
                )
        }
        .supportedFamilies([.systemSmall])
    }
}
