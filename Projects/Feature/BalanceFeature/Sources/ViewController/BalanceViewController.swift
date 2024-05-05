import UIKit

import Networks
import Domain
import FeatureDependency
import DesignSystem

import RxSwift
import RxCocoa

public final class BalanceViewController: BaseViewController {
    private let viewModel: BalanceViewModel
    
    private var dataSource: PortfolioDataSource!
    
    private lazy var ratioLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = DesignSystemAsset.chartForeground.color
        return label
    }()
    
    private lazy var portfolioTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StockInfoTVCell.self)
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
    
    public init(viewModel: BalanceViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
        configureTableView()
        bind()
    }
    
    private func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: searchBtn
        )
    }
    
    private func configureUI() {
        [ratioLabel, portfolioTableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            ratioLabel.topAnchor.constraint(
                equalTo: safeArea.topAnchor
            ),
            ratioLabel.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 20
            ),
            ratioLabel.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            
            portfolioTableView.topAnchor.constraint(
                equalTo: ratioLabel.bottomAnchor
            ),
            portfolioTableView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            portfolioTableView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            portfolioTableView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor
            ),
        ])
    }
    
    private func bind() {
        let output = viewModel.transform(
            input: .init(
                viewWillAppear: self.rx.methodInvoked(
                    #selector(UIViewController.viewWillAppear)
                )
                .map { _ in },
                stockCellTapEvent: portfolioTableView.rx.itemSelected
                    .map { $0.row },
                searchBtnTapEvent: searchBtn.rx.tap.asObservable()
            )
        )
        
        output.balanceList
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(
                onNext: { vc, responses in
                    vc.updateSnapshot(items: responses)
                }
            )
            .disposed(by: disposeBag)
        
        output.collateralRatio
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                onNext: { vc, ratio in
                    vc.ratioLabel.text = "담보 유지 비율: \(String(Int(ratio)))%"
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        dataSource = PortfolioDataSource(
            tableView: portfolioTableView,
            cellProvider: { tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: StockInfoTVCell.identifier,
                    for: indexPath
                ) as? StockInfoTVCell
                cell?.updateUI(item: item)
                return cell
            }
        )
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
