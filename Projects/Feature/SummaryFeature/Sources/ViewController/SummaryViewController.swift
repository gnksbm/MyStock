import UIKit

import Domain
import FeatureDependency

import ReactorKit
import RxSwift
import RxCocoa

public final class SummaryViewController: BaseViewController<SummaryReactor> {
    public override func bindState(reactor: SummaryReactor) {
        let state = reactor.state.share()
    }
    
    public override func bindAction(reactor: SummaryReactor) {
        rx.methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { _ in SummaryReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
