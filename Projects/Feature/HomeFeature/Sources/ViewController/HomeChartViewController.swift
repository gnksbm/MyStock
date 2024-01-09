//
//  HomeChartViewController.swift
//  HomeFeature
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import SwiftUI

import Core
import FeatureDependency
import DesignSystem

import RxSwift
import RxCocoa

final class HomeChartViewController: BaseViewController {
    private var viewModel: HomeChartViewModel
    
    let searchBtn: UIButton = {
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
    
    let candleChartCV = CandleChartCV(
        frame: .zero, collectionViewLayout: .init()
    )
    
    init(viewModel: HomeChartViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureUI()
        bind()
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
                ).map { _ in }
            )
        )
        
        output.candleList
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                onNext: { viewController, candles in
                    if let price = candles.last?.closePrice {
                        let price = String(Int(price))
                        let title = "\(viewController.viewModel.title) \(price)"
                        viewController.title = title
                    }
                    viewController.candleChartCV.setCollectionViewLayout(
                        viewController.updateLayout(itemCount: candles.count.f),
                        animated: true
                    )
                    viewController.candleChartCV.updateCandles(candles)
                }
            )
            .disposed(by: disposeBag)
    }
}

extension HomeChartViewController {
    func updateLayout(
        itemCount: CGFloat
    ) -> UICollectionViewCompositionalLayout {
        .init { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1 / itemCount),
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
