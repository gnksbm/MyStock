//
//  FavoriteCollectionView.swift
//  FavoritesFeature
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Core
import DesignSystem
import Domain
import FeatureDependency

final class FavoriteCollectionView: 
    ModernCollectionView<MarketType, KISCurrentPriceResponse> {
    override class func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let padding = DesignSystemAsset.Padding.regular
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/2),
                    heightDimension: .fractionalHeight(1)
                )
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1)
                ),
                subitems: [item]
            )
            group.interItemSpacing = .fixed(padding)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .same(inset: padding)
            section.interGroupSpacing = padding
            return section
        }
    }
}
