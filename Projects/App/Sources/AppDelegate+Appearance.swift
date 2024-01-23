//
//  AppDelegate+Appearance.swift
//  YamYamPick
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit
import DesignSystem

extension AppDelegate {
    func setupAppearance() {
        let backgroundColor = DesignSystemAsset.chartBackground.color
        let foregroundColor = DesignSystemAsset.chartForeground.color
        let accentColor = DesignSystemAsset.accentColor.color
        UINavigationBar.appearance().backgroundColor = backgroundColor
        UINavigationBar.appearance().tintColor = foregroundColor
        UITabBar.appearance().backgroundColor = backgroundColor
        UITabBar.appearance().unselectedItemTintColor = foregroundColor
        UITabBar.appearance().tintColor = accentColor
        UITabBar.appearance().isTranslucent = true
    }
}
