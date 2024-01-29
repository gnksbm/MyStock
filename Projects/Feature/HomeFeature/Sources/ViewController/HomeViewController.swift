import UIKit

import Networks
import Domain
import FeatureDependency
import DesignSystem

import RxSwift
import RxCocoa

public final class HomeViewController: BaseViewController {
    private let viewModel: HomeViewModel
    
    private lazy var collectionView: UICollectionView = {
        let layout = makeLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = DesignSystemAsset.chartBackground.color
        collectionView.register(
            HomeStockCVCell.self,
            forCellWithReuseIdentifier: HomeStockCVCell.identifier
        )
        return collectionView
    }()
    
    let searchBtn: UIButton = {
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
    
    public init(viewModel: HomeViewModel) {
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
        bind()
    }
    
    private func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: searchBtn
        )
    }
    
    private func configureUI() {
        [collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: safeArea.topAnchor
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
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
                stockCellTapEvent: collectionView.rx.itemSelected
                    .map { $0.row },
                searchBtnTapEvent: searchBtn.rx.tap.asObservable()
            )
        )
        
        output.balanceList
            .observe(on: MainScheduler.asyncInstance)
            .bind(
                to: collectionView.rx.items(
                    cellIdentifier: HomeStockCVCell.identifier,
                    cellType: HomeStockCVCell.self
                ),
                curriedArgument: { _, item, cell in
                    cell.prepare(item: item)
                }
            )
            .disposed(by: disposeBag)
        
        output.collateralRatio
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                onNext: { viewController, ratio in
                    viewController.title = String(Int(ratio))
                }
            )
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    func makeLayout() -> UICollectionViewCompositionalLayout {
        .init { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1/2),
                    heightDimension: .fractionalWidth(1/2)
                )
            )
            item.contentInsets = .init(
                top: 10,
                leading: 10,
                bottom: 10,
                trailing: 10
            )
            let hGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1/2)
                ),
                subitems: [item]
            )
            let vGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1)
                ),
                subitems: [hGroup]
            )
            let section = NSCollectionLayoutSection(group: vGroup)
            return section
        }
    }
}
