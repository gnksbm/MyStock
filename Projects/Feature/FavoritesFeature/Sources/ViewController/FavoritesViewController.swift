import UIKit

import Core
import DesignSystem

import RxSwift

public final class FavoritesViewController: UIViewController {
    private let viewModel: FavoritesViewModel
    
    private let favoritesTableView = StockInfoTableView()
    
    public init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        [favoritesTableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            favoritesTableView.topAnchor.constraint(
                equalTo: safeArea.topAnchor
            ),
            favoritesTableView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            favoritesTableView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            favoritesTableView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor
            ),
        ])
    }
}

#if DEBUG
import SwiftUI
import FeatureDependency
struct FavoritesViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIKitPreview(
            FavoritesViewController(
                viewModel: FavoritesViewModel()
            )
        )
    }
}
#endif
