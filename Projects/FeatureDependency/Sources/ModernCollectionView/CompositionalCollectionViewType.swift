//
//  CompositionalCollectionViewType.swift
//  FeatureDependency
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public protocol CompositionalCollectionViewType: AnyObject {
    static func createLayout() -> UICollectionViewCompositionalLayout
}
