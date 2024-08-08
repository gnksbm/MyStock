//
//  SearchCollectionView.swift
//  SearchStockFeature
//
//  Created by gnksbm on 8/8/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Domain
import FeatureDependency

import RxSwift
import RxCocoa

final class SearchCollectionView: 
    ModernCollectionView<SingleSection, SearchStocksResponse> {
    override class func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(50)
                )
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(50)
                ),
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    let cellTapEvent = PublishSubject<SearchStocksResponse>()
    let likeButtonTapEvent = PublishSubject<SearchStocksResponse>()
    
    override func createCellProvider() -> CellProvider {
        let cellRegistration = SearchCVCell.makeRegistration()
        return { collectionView, indexPath, item in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
            if let collectionView = collectionView as? Self {
                cell.starButton.rx.tap
                    .map { _ in item }
                    .bind(to: collectionView.likeButtonTapEvent)
                    .disposed(by: cell.disposeBag)
                
                let tapGesture = UITapGestureRecognizer()
                cell.addGestureRecognizer(tapGesture)
                tapGesture.rx.event
                    .map { _ in item }
                    .bind(to: collectionView.cellTapEvent)
                    .disposed(by: cell.disposeBag)
            }
            return cell
        }
    }
}
