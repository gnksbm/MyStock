//
//  RegistrableCellType.swift
//  FeatureDependency
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public protocol RegistrableCellType: UICollectionViewCell {
    associatedtype Item: Hashable
    
    typealias Registration<Item> =
    UICollectionView.CellRegistration<Self, Item>
    
    static func makeRegistration() -> Registration<Item>
}
