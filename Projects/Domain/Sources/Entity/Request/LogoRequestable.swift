//
//  LogoRequestable.swift
//  Domain
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public protocol LogoRequestable {
    var image: UIImage? { get set }
}

extension KISTopRankResponse: LogoRequestable { }
extension KISCheckBalanceResponse: LogoRequestable { }
extension SearchStocksResponse: LogoRequestable { }
