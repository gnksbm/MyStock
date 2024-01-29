import UIKit

import RxSwift

public final class SearchStockViewController: UIViewController {
    private let viewModel: SearchStockViewModel
    
    public init(viewModel: SearchStockViewModel) {
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
struct SearchStockViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIKitPreview(
            SearchStockViewController(
                viewModel: SearchStockViewModel()
            )
        )
    }
}
#endif
