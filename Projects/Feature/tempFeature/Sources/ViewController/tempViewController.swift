import UIKit

import RxSwift

public final class tempViewController: UIViewController {
    private let viewModel: tempViewModel
    
    public init(viewModel: tempViewModel) {
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
struct tempViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIKitPreview(
            tempViewController(
                viewModel: tempViewModel()
            )
        )
    }
}
#endif
