import UIKit

import Core
import Domain
import DesignSystem

import ReactorKit
import RxCocoa
import SnapKit

final class FavoritesViewController: UIViewController, View {
    private let stockCellTapEvent = PublishSubject<SearchStocksResponse>()
    var disposeBag = DisposeBag()
    
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
    
    private let favoritesTableView = StockInfoTableView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
    }
    
    func bind(reactor: FavoritesReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: FavoritesReactor) {
        rx.methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { _ in
                FavoritesReactor.Action.viewWillAppearEvent
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addBtn.rx.tap
            .map { _ in
                FavoritesReactor.Action.addBtnTapEvent
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        stockCellTapEvent
            .map { stockInfo in
                FavoritesReactor.Action.stockCellTapEvent(stockInfo)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: FavoritesReactor) { 
        reactor.state.map { $0.favoritesStocks }
            .distinctUntilChanged()
            .bindSnapshot(to: updateSnapshot)
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        [favoritesTableView].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        favoritesTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
    
    private func configureDataSource() {
        dataSource = .init(
            tableView: favoritesTableView
        ) { [weak self] tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StockInfoTVCell.identifier,
                for: indexPath
            ) as? StockInfoTVCell,
                  let self
            else { return .init() }
            cell.updateUI(
                image: item.image,
                ticker: item.ticker,
                name: item.name
            )
            let tapGesture = UITapGestureRecognizer()
            cell.contentView.addGestureRecognizer(tapGesture)
            tapGesture.rx.event
                .map { _ in item }
                .bind(to: self.stockCellTapEvent)
                .disposed(by: cell.disposeBag)
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
        dataSource.apply(
            snapshot,
            animatingDifferences: false
        )
    }
    
    private func configureNavigation() {
        navigationItem.rightBarButtonItem = .init(customView: addBtn)
    }
}

extension FavoritesViewController {
    final class FavoritesDataSource: FavoritesDiffableDataSource {
        override func tableView(
            _ tableView: UITableView,
            titleForHeaderInSection section: Int
        ) -> String? {
            MarketType.allCases[section].toString
        }
    }
    
    typealias FavoritesDiffableDataSource
    = UITableViewDiffableDataSource<String, SearchStocksResponse>
    typealias FavoritesSnapshot
    = NSDiffableDataSourceSnapshot<String, SearchStocksResponse>
}
