import UIKit

import RxSwift

public final class ChartViewController: UIViewController {
    private let viewModel: ChartViewModel
    
    public init(viewModel: ChartViewModel) {
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
struct ChartViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIKitPreview(
            ChartViewController(
                viewModel: ChartViewModel()
            )
        )
    }
}
#endif
