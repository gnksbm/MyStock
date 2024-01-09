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
    private let disposeBag = DisposeBag()
    
    init(
        title: String,
        ticker: String
    ) {
        self.title = title
        self.ticker = ticker
        useCase.requestRealTimePrice(ticker: ticker, marketType: .domestic)
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
        
        Observable.combineLatest(
            useCase.chartInfo,
            useCase.realTimePrice
        )
        .subscribe(
            onNext: { candles, realTimePrice in
                if let last = candles.last,
                   !realTimePrice.isEmpty {
                    var newCandles = candles
                    guard let closePrice = Double(realTimePrice)
                    else { return }
                    let newCandle = Candle(
                        date: last.date.toString(dateFormat: "yyyyMMdd"),
                        startPrice: last.startPrice,
                        lowestPrice: last.lowestPrice,
                        highestPrice: last.highestPrice,
                        closePrice: closePrice
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
    }
    
    struct Output {
        let candleList: PublishSubject<[Candle]>
    }
}
