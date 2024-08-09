import UIKit

import FeatureDependency

import RxSwift

public final class DetailViewController: BaseViewController<DetailReactor> {
    public override func bindState(reactor: DetailReactor) {
        let state = reactor.state.share()
    }
    
    public override func bindAction(reactor: DetailReactor) {
    }
    
    public override func configureLayout() {
    }
}
