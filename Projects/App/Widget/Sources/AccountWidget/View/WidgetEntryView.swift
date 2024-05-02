//
//  WidgetEntryView.swift
//  Widget
//
//  Created by gnksbm on 5/2/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import SwiftUI
import WidgetKit

@available(iOS 17, *)
struct WidgetEntryView : View {
    var entry: AccountWidgetProvider.Entry

    var body: some View {
        VStack {
            Text("오늘의 수익률")
                .bold()
            FluctuationRateView(fluctuationRate: entry.fluctuationRate)
        }
    }
}

#if DEBUG
@available(iOS 17, *)
#Preview(as: .systemSmall) {
    AccountWidget()
} timeline: {
    AccountWidgetEntry(date: .now, fluctuationRate: 0.1)
}
#endif
