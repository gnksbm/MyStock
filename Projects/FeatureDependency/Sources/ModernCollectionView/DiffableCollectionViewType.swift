//
//  DiffableCollectionViewType.swift
//  FeatureDependency
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public protocol DiffableCollectionViewType: AnyObject {
    associatedtype Section: Hashable
    associatedtype Item: Hashable
    
    typealias DiffableDataSource<Section: Hashable, Item: Hashable> =
    UICollectionViewDiffableDataSource<Section, Item>
    
    typealias CellProvider =
    (UICollectionView, IndexPath, Item) -> UICollectionViewCell?
    
    typealias Snapshot =
    NSDiffableDataSourceSnapshot<Section, Item>
    
    var diffableDataSource: DiffableDataSource<Section, Item>! { get set }
    func createCellProvider() -> CellProvider
}
