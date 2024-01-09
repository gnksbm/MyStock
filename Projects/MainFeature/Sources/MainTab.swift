//
//  MainTab.swift
//  MainFeature
//
//  Created by gnksbm on 2024/01/09.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

enum MainTab: Int, CaseIterable {
    case home, favorites, setting
    
    var tabItem: UITabBarItem {
        switch self {
        case .home:
            return .init(
                title: "홈",
                image: .init(systemName: "house"),
                tag: rawValue
            )
        case .favorites:
            return .init(
                title: "즐겨찾기",
                image: .init(systemName: "star"),
                tag: rawValue
            )
        case .setting:
            return .init(
                title: "설정",
                image: .init(systemName: "gearshape"),
                tag: rawValue
            )
        }
    }
}
