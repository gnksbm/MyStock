import UIKit

import FeatureDependency
import RxSwift

public final class HomeCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public let price = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let homeViewController = HomeViewController(
            viewModel: HomeViewModel()
        )
        price.bind {
            homeViewController.price.onNext($0)
        }.disposed(by: disposeBag)
        navigationController.setViewControllers(
            [homeViewController],
            animated: true
        )
    }
    
    public func createHomeViewController() -> UINavigationController {
        let homeViewController = HomeViewController(
            viewModel: HomeViewModel()
        )
        navigationController = UINavigationController(
            rootViewController: homeViewController
        )
        return navigationController
    }
}
