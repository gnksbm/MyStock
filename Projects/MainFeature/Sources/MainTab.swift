//
//  MainTab.swift
//  MainFeature
//
//  Created by gnksbm on 2024/01/09.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

enum MainTab: Int, CaseIterable {
    case home, search, favorites, setting
    
    var tabItem: UITabBarItem {
        switch self {
        case .home:
            .init(
                title: "홈",
                image: .init(systemName: "house"),
                tag: rawValue
            )
        case .search:
            .init(
                title: "검색",
                image: .init(systemName: "magnifyingglass"),
                tag: rawValue
            )
        case .favorites:
            .init(
                title: "즐겨찾기",
                image: .init(systemName: "star"),
                tag: rawValue
            )
        case .setting:
            .init(
                title: "설정",
                image: .init(systemName: "gearshape"),
                tag: rawValue
            )
        }
    }
}
