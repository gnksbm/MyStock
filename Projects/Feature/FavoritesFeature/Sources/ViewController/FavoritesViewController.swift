import UIKit

import RxSwift

public final class FavoritesViewController: UIViewController {
    private let viewModel: FavoritesViewModel
    
    public init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
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
