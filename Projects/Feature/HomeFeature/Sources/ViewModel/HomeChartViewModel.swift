//
//  HomeChartViewModel.swift
//  HomeFeature
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift
import RxRelay

final class HomeChartViewModel: ViewModel {
    @Injected(HomeChartUseCase.self) private var useCase: HomeChartUseCase
    private let ticker: String
    private let disposeBag = DisposeBag()
    
    init(ticker: String) {
        self.ticker = ticker
        useCase.requestRealTimePrice(ticker: "DNASAAPL", marketType: .overseas)
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            candleList: .init()
        )
        
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    let date = Date()
                    viewModel.useCase.fetchChart(
                        period: .day,
                        ticker: viewModel.ticker,
                        startDate: Date(
                            timeInterval: 86400 * -30,
                            since: date
                        ).toString(dateFormat: "yyyyMMdd"),
                        endDate: date.toString(dateFormat: "yyyyMMdd")
                    )
                }
            )
            .disposed(by: disposeBag)
        
        useCase.chartInfo
            .subscribe(
                onNext: {
                    output.candleList.onNext($0)
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension HomeChartViewModel {
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let candleList: PublishSubject<[Candle]>
    }
}
