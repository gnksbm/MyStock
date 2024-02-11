import UIKit
import Core
import FeatureDependency
import DesignSystem

import RxSwift
import RxCocoa

final class ChartViewController: BaseViewController {
    private var viewModel: ChartViewModel
    
    private var dataSource
    : UICollectionViewDiffableDataSource<Int, CandleShape>!
    
    private let searchBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        let image = UIImage(systemName: "magnifyingglass")
        let imgConfig = UIImage.SymbolConfiguration(
            font: .boldSystemFont(ofSize: 20)
        )
        config.image = image
        config.preferredSymbolConfigurationForImage = imgConfig
        let button = UIButton(configuration: config)
        return button
    }()
    
    private lazy var candleChartCV: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        collectionView.backgroundColor = DesignSystemAsset.chartBackground.color
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.startAnimating()
        collectionView.backgroundView = activityIndicatorView
        return collectionView
    }()
    
    init(viewModel: ChartViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureUI()
        bind()
        configureDataSource()
    }
    
    private func configureUI() {
        [candleChartCV].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            candleChartCV.topAnchor.constraint(equalTo: safeArea.topAnchor),
            candleChartCV.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            candleChartCV.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            candleChartCV.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor
            ),
        ])
    }
    
    private func bind() {
        let output = viewModel.transform(
            input: .init(
                viewWillAppear: self.rx.methodInvoked(
                    #selector(UIViewController.viewWillAppear)
                ).map { _ in },
                viewWillDisappear: self.rx.methodInvoked(
                    #selector(UIViewController.viewWillDisappear)
                ).map { _ in }
            )
        )
        
        output.candleList
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                onNext: { viewController, candles in
                    if let price = candles.sorted(
                        by: { $0.date < $1.date }
                    ).last?.close {
                        let price = String(Int(price))
                        let title = "\(viewController.viewModel.title) \(price)"
                        viewController.title = title
                    }
                    viewController.updateSnapshot(candles)
                    viewController.candleChartCV.backgroundView = nil
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() {
        let registration = makeRegistration()
        dataSource = UICollectionViewDiffableDataSource<Int, CandleShape>(
            collectionView: candleChartCV
        ) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: item
            )
        }
    }
    
    private func updateSnapshot(_ candles: [Candle]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CandleShape>()
        let shapes = candles.map { candle in
            CandleShape(
                viewHeight: candleChartCV.bounds.height,
                viewWidth: candleChartCV.bounds.width,
                highestPrice: candles.highestPrice,
                lowestPrice: candles.lowestPrice,
                totalCandleCount: candles.count.f,
                candle: candle
            )
        }
        snapshot.appendSections([0])
        snapshot.appendItems(shapes, toSection: 0)
        candleChartCV.setCollectionViewLayout(
            updateLayout(itemCount: candles.count.f),
            animated: false
        )
        dataSource.apply(
            snapshot,
            animatingDifferences: false
        )
    }
    
    private func makeRegistration(
    ) -> UICollectionView.CellRegistration<CandleChartCVCell, CandleShape> {
        .init { cell, _, shape in
            cell.drawCandle(shape: shape)
        }
    }
}

extension ChartViewController {
    func updateLayout(
        itemCount: CGFloat,
        minCellSize: CGFloat = 3
    ) -> UICollectionViewCompositionalLayout {
        let cellCount = CGFloat.screenWidth / itemCount < minCellSize ?
        CGFloat.screenWidth / minCellSize :
        itemCount
        return .init { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1 / cellCount),
                    heightDimension: .fractionalHeight(1)
                )
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ),
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}
