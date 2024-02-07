import UIKit

import Core
import DesignSystem

import RxSwift

public final class FavoritesViewController: UIViewController {
    private let viewModel: FavoritesViewModel
    
    private let addBtnTapEvent = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
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
        setDelegate()
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
    
    func setDelegate() {
        favoritesTableView.register(FavoritesFooterView.self)
        favoritesTableView.delegate = self
    }
}

extension FavoritesViewController: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: FavoritesFooterView.identifier
        ) as? FavoritesFooterView
        let tapGesture = UITapGestureRecognizer()
        footer?.contentView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .map { _ in }
            .bind(to: addBtnTapEvent)
            .disposed(by: disposeBag)
        return footer
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}
