//
//  SummaryCollectionView.swift
//  SummaryFeature
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Core
import DesignSystem
import Domain

import RxSwift

final class SummaryCollectionView:
    ModernCollectionView<SummarySection, SummaryItem> {
    override class func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            var section: NSCollectionLayoutSection
            switch SummarySection.allCases[sectionIndex] {
            case .favorite:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                let groupDemension = 0.85/2
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(groupDemension),
                        heightDimension: .fractionalWidth(groupDemension)
                    ),
                    subitems: [item, item]
                )
                group.contentInsets = NSDirectionalEdgeInsets(
                    top: 15,
                    leading: 0,
                    bottom: 0,
                    trailing: 30
                )
                section = NSCollectionLayoutSection(group: group)
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
                section = NSCollectionLayoutSection(group: group)
            }
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
    
    let cellTapEvent = PublishSubject<SummaryItem>()
    
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
        let topRankRegistration = TopRankCVCell.makeRegistration()
        let favoriteRegistration = FavoriteCVCell.makeRegistration()
        return { collectionView, indexPath, item in
            switch Section.allCases[indexPath.section] {
            case .favorite:
                if case .favorite(let response) = item {
                    let cell = collectionView.dequeueConfiguredReusableCell(
                        using: favoriteRegistration,
                        for: indexPath,
                        item: response
                    )
                    if let collectionView = collectionView as? Self {
                        let tapGesture = UITapGestureRecognizer()
                        cell.addGestureRecognizer(tapGesture)
                        tapGesture.rx.event
                            .map { _ in item }
                            .bind(to: collectionView.cellTapEvent)
                            .disposed(by: cell.disposeBag)
                    }
                    return cell
                } else { return nil }
            case .topVolume, .topMarketCap:
                if case .topRank(let response) = item {
                    let cell = collectionView.dequeueConfiguredReusableCell(
                        using: topRankRegistration,
                        for: indexPath,
                        item: response
                    )
                    if let collectionView = collectionView as? Self {
                        let tapGesture = UITapGestureRecognizer()
                        cell.addGestureRecognizer(tapGesture)
                        tapGesture.rx.event
                            .map { _ in item }
                            .bind(to: collectionView.cellTapEvent)
                            .disposed(by: cell.disposeBag)
                    }
                    return cell
                } else { return nil }
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
    case favorite, topVolume, topMarketCap
    
    var title: String {
        switch self {
        case .favorite:
            "나의 즐겨찾기"
        case .topVolume:
            "거래량 상위 30"
        case .topMarketCap:
            "시가총액 상위 30"
        }
    }
}

enum SummaryItem: Hashable {
    case favorite(KISCurrentPriceResponse)
    case topRank(KISTopRankResponse)
}
