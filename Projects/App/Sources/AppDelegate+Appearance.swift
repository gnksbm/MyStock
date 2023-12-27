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
        UITabBar.appearance().tintColor = DesignSystemAsset.accentColor.color
        UITabBar.appearance().isTranslucent = true
    }
}
