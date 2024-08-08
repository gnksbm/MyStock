//
//  SummaryCollectionView.swift
//  SummaryFeature
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import DesignSystem
import Domain
import FeatureDependency

final class SummaryCollectionView:
    ModernCollectionView<SummarySection, SummaryItem> {
    override class func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch SummarySection.allCases[sectionIndex] {
            case .topVolume, .topMarketCap:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(40)
                    )
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.85),
                        heightDimension: .estimated(40)
                    ),
                    subitems: [item, item, item]
                )
                group.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: 0,
                    bottom: 0,
                    trailing: 30
                )
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: 30,
                    bottom: 30,
                    trailing: 30
                )
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .estimated(1)
                        ),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                ]
                return section
            }
        }
    }
    
    override func configureDataSource() {
        super.configureDataSource()
        let headerRegistration = makeHeaderRegistration()
        diffableDataSource.supplementaryViewProvider
        = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
        }
    }
    
    override func createCellProvider() -> CellProvider {
        let topVolumeRegistration = TopRankCVCell.makeRegistration()
        return { collectionView, indexPath, item in
            switch Section.allCases[indexPath.section] {
            case .topVolume, .topMarketCap:
                if case .topRank(let response) = item {
                    collectionView.dequeueConfiguredReusableCell(
                        using: topVolumeRegistration,
                        for: indexPath,
                        item: response
                    )
                } else { nil }
            }
        }
    }
    
    override func configureUI() {
        backgroundColor = DesignSystemAsset.chartBackground.color
    }
    
    private func makeHeaderRegistration(
    ) -> UICollectionView.SupplementaryRegistration<UICollectionViewCell> {
        UICollectionView.SupplementaryRegistration<UICollectionViewCell>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { header, _, indexPath in
            var config = UIListContentConfiguration.plainHeader()
            config.text = SummarySection.allCases[indexPath.section].title
            config.textProperties.font = UIFont.boldSystemFont(ofSize: 25)
            config.textProperties.color = .label
            header.contentConfiguration = config
        }
    }
}

enum SummarySection: CaseIterable {
    case topVolume, topMarketCap
    
    var title: String {
        switch self {
        case .topVolume:
            "거래량 상위 30"
        case .topMarketCap:
            "시가총액 상위 30"
        }
    }
}

enum SummaryItem: Hashable {
    case topRank(KISTopRankResponse)
}
