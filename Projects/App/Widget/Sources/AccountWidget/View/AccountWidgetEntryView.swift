//
//  AccountWidgetEntryView.swift
//  Widget
//
//  Created by gnksbm on 5/2/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import SwiftUI
import WidgetKit

import Core
import Domain

struct AccountWidgetEntryView : View {
    var entry: AccountWidgetProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(entry.date.toString(dateFormat: "MM.dd"))
                Spacer()
            }
            FluctuationRateView(
                balanceResponseList: entry.balanceResponseList.combineSameTiker
            )
            Spacer()
        }
        .bold()
    }
    
    func rateToImage(_ rate: Double) -> Image {
        switch rate {
        case ..<0:
            return .init(systemName: "chart.line.downtrend.xyaxis")
        case 0:
            return .init(systemName: "chart.line.flattrend.xyaxis")
        default:
            return .init(systemName: "chart.line.uptrend.xyaxis")
        }
    }
}

#if DEBUG
struct AccountWidget_Preview: PreviewProvider {
    static var previews: some View {
        AccountWidgetEntryView(entry: .mock)
            .widgetBackground()
            .previewContext(
                WidgetPreviewContext(family: .systemMedium)
            )
    }
}
#endif
