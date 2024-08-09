import UIKit

import Core
import Domain
import DesignSystem
import FeatureDependency
import ThirdPartyLibs

import ReactorKit
import RxCocoa
import SnapKit

public final class FavoritesViewController:
    BaseViewController<FavoritesReactor> {
    private let collectionView = FavoriteCollectionView()
    
    public override func bindState(reactor: FavoritesReactor) {
        disposeBag.insert {
            reactor.state.map { $0.favoritesStocks }
                .distinctUntilChanged()
                .bind(with: self) { vc, items in
                    vc.collectionView.applyItem { section in
                        items.filter { $0.marketType == section }
                    }
                }
        }
    }
    
    public override func bindAction(reactor: FavoritesReactor) {
        disposeBag.insert {
            rx.methodInvoked(#selector(UIViewController.viewWillAppear))
                .map { _ in
                    FavoritesReactor.Action.viewWillAppearEvent
                }
                .bind(to: reactor.action)
            
            collectionView.cellTapEvent
                .map { stockInfo in
                    FavoritesReactor.Action.stockCellTapEvent(stockInfo)
                }
                .bind(to: reactor.action)
        }
    }
    
    public override func configureLayout() {
        collectionView.snp.equalToSafeArea(view)
    }
    
    private func updateSnapshot(responses: [SearchStocksResponse]) {
//        snapshot = .init()
//        snapshot.appendSections(MarketType.allCases.map { $0.toString })
//        MarketType.allCases.forEach { marketType in
//            snapshot.appendItems(
//                responses.filter { response in
//                    response.marketType == marketType
//                },
//                toSection: marketType.toString
//            )
//        }
//        dataSource.apply(
//            snapshot,
//            animatingDifferences: false
//        )
    }
}
