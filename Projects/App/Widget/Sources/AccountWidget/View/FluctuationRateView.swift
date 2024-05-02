//
//  FluctuationRateView.swift
//  Widget
//
//  Created by gnksbm on 5/2/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import SwiftUI
import WidgetKit

import Core
import DesignSystem
import Domain

struct FluctuationRateView: View {
    let balanceResponseList: [KISCheckBalanceResponse]
    
    var body: some View {
        VStack {
            ForEach(
                balanceResponseList.prefix(3),
                id: \.hashValue
            ) { balance in
                HStack {
                    Text(balance.name)
                    Spacer()
                    Text(balance.rateToDoubleDigits + " %")
                        .layoutPriority(999)
                }
                .lineLimit(1)
                .foregroundStyle(
                    rateToColor(balance.fluctuationRate)
                )
            }
        }
    }
    
    func rateToColor(_ rate: String) -> Color {
        guard let rateDouble = Double(rate)
        else { return .black }
        switch rateDouble {
        case ..<0:
            return .init(DesignSystemAsset.loss.color)
        case 0:
            return .primary
        default:
            return .init(DesignSystemAsset.profit.color)
        }
    }
}

#if DEBUG
struct FluctuationRateView_Preview: PreviewProvider {
    static var previews: some View {
        FluctuationRateView(
            balanceResponseList: AccountWidgetEntry.mock.balanceResponseList
        )
        .widgetBackground()
        .previewContext(
            WidgetPreviewContext(family: .systemSmall)
        )
    }
}
#endif
