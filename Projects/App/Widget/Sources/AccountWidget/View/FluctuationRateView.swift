//
//  FluctuationRateView.swift
//  Widget
//
//  Created by gnksbm on 5/2/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import SwiftUI
import Core
import DesignSystem

struct FluctuationRateView: View {
    let fluctuationRate: Double
    
    var body: some View {
        Text(String(format: "%.2f", fluctuationRate) + " %")
            .foregroundStyle(rateColor)
    }
    
    var rateColor: Color {
        switch fluctuationRate {
        case ..<0:
            return DesignSystemAsset.loss.swiftUIColor
        case 0:
            return .black
        default:
            return DesignSystemAsset.profit.swiftUIColor
        }
    }
}

#if DEBUG
@available(iOS 17, *)
#Preview {
    VStack {
        FluctuationRateView(fluctuationRate: 0.14)
        FluctuationRateView(fluctuationRate: 0)
        FluctuationRateView(fluctuationRate: -0.14)
    }
}
#endif
