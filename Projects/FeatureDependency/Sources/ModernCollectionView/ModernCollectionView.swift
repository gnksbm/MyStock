//
//  ModernCollectionView.swift
//  FeatureDependency
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

protocol ModernCollectionViewType:
    DiffableCollectionViewType, CompositionalCollectionViewType, AnyObject { }

open class ModernCollectionView<Section: Hashable, Item: Hashable>:
    UICollectionView, ModernCollectionViewType {
    public class func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout.list(
            using: UICollectionLayoutListConfiguration(appearance: .plain)
        )
    }
    
    public var diffableDataSource: DiffableDataSource<Section, Item>!
    open var cellProvider: CellProvider { { _, _, _ in nil } }
    
    public init() {
        super.init(
            frame: .zero,
            collectionViewLayout: Self.createLayout()
        )
        configureDataSource()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getItem(
        for indexPath: IndexPath
    ) -> Item where Section: CaseIterable, Section.AllCases.Index == Int {
        let section = Section.allCases[indexPath.section]
        return diffableDataSource.snapshot(for: section).items[indexPath.row]
    }
    
    open func configureDataSource() {
        diffableDataSource = DiffableDataSource(
            collectionView: self,
            cellProvider: cellProvider
        )
    }
    
    public func applyItem(
        _ sectionHandler: (Section) -> [Item],
        withAnimating: Bool = true
    ) where Section: CaseIterable {
        var snapshot = Snapshot()
        Section.allCases.forEach { section in
            snapshot.appendSections([section])
            let items = sectionHandler(section)
            snapshot.appendItems(
                items,
                toSection: section
            )
        }
        diffableDataSource.apply(
            snapshot,
            animatingDifferences: withAnimating
        )
    }
    
    public func appendItem(
        _ sectionHandler: (Section) -> [Item],
        withAnimating: Bool = true
    ) where Section: CaseIterable {
        var snapshot = diffableDataSource.snapshot()
        Section.allCases.forEach { section in
            if !snapshot.sectionIdentifiers.contains(section) {
                snapshot.appendSections([section])
            }
            snapshot.appendItems(
                sectionHandler(section),
                toSection: section
            )
        }
        diffableDataSource.apply(
            snapshot,
            animatingDifferences: withAnimating
        )
    }
    
    public func updateItems(
        _ items: [Item],
        withAnimating: Bool = true
    ) where Item: Identifiable {
        var snapshot = diffableDataSource.snapshot()
        items.forEach { newItem in
            if let oldItem = snapshot.itemIdentifiers.first(
                where: { oldItem in
                    oldItem.id == newItem.id
                }
            ),
               let section = snapshot.sectionIdentifier(
                containingItem: oldItem
            ) {
                var items = snapshot.itemIdentifiers(inSection: section)
                snapshot.deleteItems(items)
                guard let index = items.firstIndex(of: oldItem) else { return }
                items.remove(at: index)
                items.insert(newItem, at: index)
                snapshot.appendItems(items, toSection: section)
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.diffableDataSource.apply(
                snapshot,
                animatingDifferences: withAnimating
            )
        }
    }
    
    // SingleSection
    public func getItem(
        for indexPath: IndexPath
    ) -> Item where Section == SingleSection {
        return diffableDataSource.snapshot(for: .main).items[indexPath.row]
    }
    
    public func applyItem(
        items: [Item],
        withAnimating: Bool = true
    ) where Section == SingleSection {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        diffableDataSource.apply(
            snapshot,
            animatingDifferences: withAnimating
        )
    }
    
    public func appendItem(
        items: [Item],
        withAnimating: Bool = true
    ) where Section == SingleSection {
        var snapshot = diffableDataSource.snapshot()
        if !snapshot.sectionIdentifiers.contains(.main) {
            snapshot.appendSections([.main])
        }
        snapshot.appendItems(items)
        diffableDataSource.apply(
            snapshot,
            animatingDifferences: withAnimating
        )
    }
}

public enum SingleSection {
    case main
}
