import UIKit

import Core
import Domain
import FeatureDependency
import ThirdPartyLibs

import ReactorKit
import RxSwift
import RxCocoa

public final class SummaryViewController: BaseViewController<SummaryReactor> {
    private let collectionView = SummaryCollectionView()
    
    public override func bindState(reactor: SummaryReactor) {
        let state = reactor.state.share()
        
        disposeBag.insert {
            state.map { $0.topVolumeItems }
                .observe(on: MainScheduler.instance)
                .withUnretained(self)
                .subscribe(
                    onNext: { vc, items in
                        vc.collectionView.replaceItem(
                            for: .topVolume,
                            items: items.map { .topRank($0) }
                        )
                    }
                )
            
            state.map { $0.topMarketCapItems }
                .observe(on: MainScheduler.instance)
                .withUnretained(self)
                .subscribe(
                    onNext: { vc, items in
                        vc.collectionView.replaceItem(
                            for: .topMarketCap,
                            items: items.map { .topRank($0) }
                        )
                    }
                )
        }
    }
    
    public override func bindAction(reactor: SummaryReactor) {
        disposeBag.insert {
            rx.methodInvoked(#selector(Self.viewWillAppear))
                .withLatestFrom(reactor.state.map { $0.topVolumeItems.isEmpty })
                .skip { !$0 }
                .map { _ in SummaryReactor.Action.viewWillAppear }
                .bind(to: reactor.action)
            
            collectionView.cellTapEvent
                .compactMap { item in
                    switch item {
                    case .favorite(let item):
                        SummaryReactor.Action.itemSelected(ticker: item.ticker)
                    case .topRank(let item):
                        SummaryReactor.Action.itemSelected(ticker: item.ticker)
                    }
                }
                .bind(to: reactor.action)
        }
    }
    
    public override func configureLayout() {
        collectionView.snp.equalToSafeArea(view)
    }
}
