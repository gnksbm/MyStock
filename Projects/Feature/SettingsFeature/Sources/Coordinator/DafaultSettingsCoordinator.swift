import UIKit

import FeatureDependency

public final class DefaultSettingsCoordinator: SettingsCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let settingsViewController = SettingsViewController(
            viewModel: SettingsViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [settingsViewController],
            animated: false
        )
    }
    
    public func startApiSettingFlow() {
        let apiSettingsCoordinator = DefaultAPISettingsCoordinator(
            parent: self,
            navigationController: navigationController
        )
        childs.append(apiSettingsCoordinator)
        apiSettingsCoordinator.start()
    }
}
