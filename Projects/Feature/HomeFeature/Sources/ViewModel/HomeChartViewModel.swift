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
    let title: String
    private let ticker: String
    private let marketType: MarketType
    private let disposeBag = DisposeBag()
    
    init(
        title: String,
        ticker: String,
        marketType: MarketType
    ) {
        self.title = title
        self.ticker = ticker
        self.marketType = marketType
    }
    
    deinit {
        print(String(describing: self), #function)
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
                        marketType: viewModel.marketType,
                        ticker: viewModel.ticker,
                        startDate: Date(
                            timeInterval: 86400 * -100,
                            since: date
                        ).toString(dateFormat: "yyyyMMdd"),
                        endDate: date.toString(dateFormat: "yyyyMMdd")
                    )
                }
            )
            .disposed(by: disposeBag)
        
        input.viewWillDisappear
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.disconnectRealTimePrice()
                }
            )
            .disposed(by: disposeBag)
        
        useCase.chartInfo
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.connectRealTimePrice(
                        ticker: viewModel.ticker,
                        marketType: viewModel.marketType
                    )
                }
            )
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            useCase.chartInfo,
            useCase.realTimePrice
        )
        .subscribe(
            onNext: { candles, realTimePrice in
                let sortedCandles = candles.sorted(by: { $0.date < $1.date })
                if let last = sortedCandles.last,
                   !realTimePrice.isEmpty {
                    var newCandles = sortedCandles
                    guard let closePrice = Double(realTimePrice)
                    else { return }
                    let newCandle = Candle(
                        date: last.date.toString(dateFormat: "yyyyMMdd"),
                        open: last.open,
                        low: last.low,
                        high: last.high,
                        close: closePrice
                    )
                    newCandles.removeLast()
                    newCandles.append(newCandle)
                    output.candleList.onNext(newCandles)
                    return
                }
                output.candleList.onNext(candles)
            }
        )
        .disposed(by: disposeBag)
        
        return output
    }
    
}

extension HomeChartViewModel {
    struct Input {
        let viewWillAppear: Observable<Void>
        let viewWillDisappear: Observable<Void>
    }
    
    struct Output {
        let candleList: PublishSubject<[Candle]>
    }
}
