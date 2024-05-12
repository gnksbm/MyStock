import UIKit

import DesignSystem

import RxSwift
import RxCocoa
import SnapKit

public final class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel
    
    private let editAPIKeyBtn = SettingsButton(
        title: "API Key 설정하기",
        icon: UIImage(systemName: "key"),
        isNavigationBtn: true
    )
    
    private lazy var stackView: UIStackView = {
        let accentColor = DesignSystemAsset.accentColor.color
        let stackView = UIStackView(arrangedSubviews: [editAPIKeyBtn])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func configureUI() {
        [stackView].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        stackView.snp.makeConstraints { make in
            make.top.width.centerX.equalTo(safeArea)
        }
    }
    
    private func bind() {
        _ = viewModel.transform(
            input: .init(
                apiBtnTapEvent: editAPIKeyBtn.rx.tap.asObservable()
            )
        )
    }
}
