//
//  SummaryCollectionView.swift
//  SummaryFeature
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Domain
import FeatureDependency

final class SummaryCollectionView:
    ModernCollectionView<SummarySection, SummaryItem> {
    override class func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch SummarySection.allCases[sectionIndex] {
            case .topVolume:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1/4)
                    )
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1/4)
                    ),
                    subitems: [item]
                )
                group.contentInsets = .same(inset: 20)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: 20,
                    bottom: 0,
                    trailing: 0
                )
                return section
            }
        }
    }

    override var cellProvider: CellProvider {
        let topVolumeRegistration = TopVolumeCVCell.makeRegistration()
        return { collectionView, indexPath, item in
            switch Section.allCases[indexPath.section] {
            case .topVolume:
                if case .topVolume(let response) = item {
                    collectionView.dequeueConfiguredReusableCell(
                        using: topVolumeRegistration,
                        for: indexPath,
                        item: response
                    )
                } else { nil }
            }
        }
    }
}

enum SummarySection: CaseIterable {
    case topVolume
}

enum SummaryItem: Hashable {
    case topVolume(KISTopVolumeResponse)
}
