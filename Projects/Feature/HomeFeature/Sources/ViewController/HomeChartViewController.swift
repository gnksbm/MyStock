//
//  HomeChartViewController.swift
//  HomeFeature
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import SwiftUI

import FeatureDependency
import DesignSystem

import RxSwift
import RxCocoa

final class HomeChartViewController: BaseViewController {
    let chartVC = UIHostingController(rootView: CandleChartView(candles: []))
    var viewModel: HomeChartViewModel
    
    init(viewModel: HomeChartViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureUI()
    }
    
    private func configureUI() {
        guard let chartView = chartVC.view else { return }
        [chartView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            chartView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
}
