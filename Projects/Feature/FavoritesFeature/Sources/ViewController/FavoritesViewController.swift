import UIKit

import Core
import Domain
import DesignSystem

import RxSwift

public final class FavoritesViewController: UIViewController {
    private let viewModel: FavoritesViewModel
    
    private let addBtnTapEvent = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    private var dataSource: FavoritesDataSource!
    private var snapshot: FavoritesSnapshot!
    
    private let addBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        let font = UIFont.boldSystemFont(ofSize: 20)
        let image = UIImage(systemName: "plus")
        let imgConfig = UIImage.SymbolConfiguration(
            font: font
        )
        config.image = image
        config.preferredSymbolConfigurationForImage = imgConfig
        let button = UIButton(configuration: config)
        return button
    }()
    
    private lazy var favoritesTableView: StockInfoTableView = {
        let tableView = StockInfoTableView()
        return tableView
    }()
    
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
        bind()
        configureDataSource()
        configureNavigation()
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
    
    private func bind() {
        let output = viewModel.transform(
            input: .init(
                addBtnTapEvent: addBtn.rx.tap.asObservable()
            )
        )
        
        output.favoritesStocks
            .withUnretained(self)
            .subscribe(
                onNext: { viewController, responses in
                    viewController.updateSnapshot(responses: responses)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() {
        dataSource = .init(
            tableView: favoritesTableView
        ) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StockInfoTVCell.identifier,
                for: indexPath
            ) as? StockInfoTVCell
            else { return .init() }
            cell.updateUI(
                ticker: item.ticker,
                name: item.name
            )
            return cell
        }
        snapshot = .init()
        snapshot.appendSections(MarketType.allCases.map { $0.toString })
        dataSource.apply(snapshot)
    }
    
    private func updateSnapshot(responses: [SearchStocksResponse]) {
        snapshot = .init()
        snapshot.appendSections(MarketType.allCases.map { $0.toString })
        MarketType.allCases.forEach { marketType in
            snapshot.appendItems(
                responses.filter { response in
                    response.marketType == marketType
                },
                toSection: marketType.toString
            )
        }
        dataSource.apply(snapshot)
    }
    
    private func configureNavigation() {
        navigationItem.rightBarButtonItem = .init(customView: addBtn)
    }
}

extension FavoritesViewController {
    final class FavoritesDataSource: FavoritesDiffableDataSource {
        override func tableView(
            _ tableView: UITableView,
            titleForFooterInSection section: Int
        ) -> String? {
            MarketType.allCases[section].toString
        }
    }
    
    typealias FavoritesDiffableDataSource
    = UITableViewDiffableDataSource<String, SearchStocksResponse>
    typealias FavoritesSnapshot
    = NSDiffableDataSourceSnapshot<String, SearchStocksResponse>
}
