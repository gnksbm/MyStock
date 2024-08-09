import UIKit

import Core
import DesignSystem

import ReactorKit
import SnapKit

final class SettingsViewController: BaseViewController<SettingsReactor> {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func bindAction(reactor: SettingsReactor) {
        editAPIKeyBtn.rx.tap
            .map { _ in SettingsReactor.Action.apiBtnTapEvent }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: SettingsReactor) { }
    
    override func configureLayout() {
        [stackView].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        stackView.snp.makeConstraints { make in
            make.top.width.centerX.equalTo(safeArea)
        }
    }
}
