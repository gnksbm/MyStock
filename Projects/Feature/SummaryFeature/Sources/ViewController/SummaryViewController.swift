import UIKit

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
                        vc.collectionView.applyItem(
                            for: .topVolume,
                            items: items.map { .topVolume($0) }
                        )
                    }
                )
        }
    }
    
    public override func bindAction(reactor: SummaryReactor) {
        rx.methodInvoked(#selector(UIViewController.viewWillAppear))
            .withLatestFrom(reactor.state.map { $0.topVolumeItems.isEmpty })
            .map { _ in SummaryReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    public override func configureLayout() {
        collectionView.snp.equalToSafeArea(view)
    }
}
