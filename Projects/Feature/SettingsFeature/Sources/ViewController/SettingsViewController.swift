import UIKit

import DesignSystem

import RxSwift
import RxCocoa

public final class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel
    
    private let editAPIKeyBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = .systemFont(
            ofSize: 20,
            weight: .semibold
        )
        titleContainer.foregroundColor = DesignSystemAsset.chartForeground.color
        config.attributedTitle = AttributedString(
            "API Key 설정하기",
            attributes: titleContainer
            )
        let button = UIButton(configuration: config)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [editAPIKeyBtn])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .top
        stackView.addDivider(color: DesignSystemAsset.accentColor.color)
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
    }
    
    private func configureUI() {
        [stackView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            stackView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    private func bind() {
        viewModel.transform(
            input: .init(
                apiBtnTapEvent: editAPIKeyBtn.rx.tap.asObservable()
            )
        )
    }
}
