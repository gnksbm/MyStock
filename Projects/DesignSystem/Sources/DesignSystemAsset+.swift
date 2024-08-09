//
//  DesignSystemAsset+.swift
//  DesignSystem
//
//  Created by gnksbm on 5/5/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public extension String {
    var toColorForNumeric: UIColor {
        guard let num = Double(self)
        else { return DesignSystemAsset.chartForeground.color }
        switch num {
        case ..<0:
            return DesignSystemAsset.blackCandle.color
        case 0:
            return DesignSystemAsset.chartForeground.color
        default:
            return DesignSystemAsset.whiteCandle.color
        }
    }
}

public extension DesignSystemAsset {
    enum Padding {
        public static let regular: CGFloat = 20
    }
    
    enum Demension {
        public static let logoImage: CGFloat = 40
    }
    
    enum Radius {
        public static let regular: CGFloat = 8
        public static let medium: CGFloat = 15
        public static let logoImage: CGFloat = Demension.logoImage / 2
    }
}
