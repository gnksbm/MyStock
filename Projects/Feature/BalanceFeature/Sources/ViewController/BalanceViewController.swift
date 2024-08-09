import UIKit

import Core
import Domain
import DesignSystem

import ReactorKit
import RxCocoa
import SnapKit

final class BalanceViewController: BaseViewController<BalanceReactor> {
    private var dataSource: PortfolioDataSource!
    
    private lazy var ratioLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = DesignSystemAsset.chartForeground.color
        return label
    }()
    
    private lazy var portfolioTableView: UITableView = {
        let tableView = UITableView()
//        tableView.register(StockInfoTVCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = DesignSystemAsset.chartBackground.color
        tableView.separatorColor = DesignSystemAsset.chartForeground.color
        return tableView
    }()
    
    private let searchBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        let image = UIImage(systemName: "magnifyingglass")
        let imgConfig = UIImage.SymbolConfiguration(
            font: .boldSystemFont(ofSize: 20)
        )
        config.image = image
        config.preferredSymbolConfigurationForImage = imgConfig
        let button = UIButton(configuration: config)
        button.tintColor = DesignSystemAsset.accentColor.color
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
        configureTableView()
    }
    
    private func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: searchBtn
        )
    }
    
    override func configureUI() {
        [ratioLabel, portfolioTableView].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        ratioLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(safeArea)
            make.leading.equalTo(safeArea).offset(20)
        }
        
        portfolioTableView.snp.makeConstraints { make in
            make.top.equalTo(ratioLabel.snp.bottom)
            make.leading.trailing.bottom.equalTo(safeArea)
        }
    }
    
    override func bindAction(reactor: BalanceReactor) {
        rx.methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { _ in BalanceReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        portfolioTableView.rx.itemSelected
            .map { indexPath in
                BalanceReactor.Action.stockCellTapEvent(index: indexPath.row)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchBtn.rx.tap
            .map { _ in
                BalanceReactor.Action.searchBtnTapEvent
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: BalanceReactor) {
        let state = reactor.state
            .share()
        
        state.map { $0.balanceList }
            .observe(on: MainScheduler.asyncInstance)
            .bindSnapshot(to: updateSnapshot)
            .disposed(by: disposeBag)
        
        state.map { $0.collateralRatioMsg }
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe { vc, message in
                vc.ratioLabel.text = message
            }
            .disposed(by: disposeBag)
    }
    
    private func configureTableView() {
//        dataSource = PortfolioDataSource(
//            tableView: portfolioTableView,
//            cellProvider: { tableView, indexPath, item in
//                let cell = tableView.dequeueReusableCell(
//                    withIdentifier: StockInfoTVCell.identifier,
//                    for: indexPath
//                ) as? StockInfoTVCell
//                cell?.updateUI(item: item)
//                return cell
//            }
//        )
    }
    
    private func updateSnapshot(items: [KISCheckBalanceResponse]) {
        var snapshot = PortfolioSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource.apply(
            snapshot,
            animatingDifferences: false
        )
    }
}

extension BalanceViewController {
    typealias PortfolioDataSource
    = UITableViewDiffableDataSource<Int, KISCheckBalanceResponse>
    typealias PortfolioSnapshot
    = NSDiffableDataSourceSnapshot<Int, KISCheckBalanceResponse>
}
