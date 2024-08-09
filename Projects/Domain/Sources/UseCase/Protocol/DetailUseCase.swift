//
//  DetailUseCase.swift
//  Domain
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxSwift

public protocol DetailUseCase {
    func fetchDetailItem(
        ticker: String
    ) -> Observable<KISDailyChartPriceResponse>
}
