//
//  LogoResponse.swift
//  Domain
//
//  Created by gnksbm on 5/5/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public struct LogoResponse {
    public let ticker: String
    public let logo: UIImage?
    
    public init(
        ticker: String,
        logo: UIImage?
    ) {
        self.ticker = ticker
        self.logo = logo
    }
}

public protocol LogoNecessary {
    var ticker: String { get }
    var image: UIImage? { get set }
}

public extension Array<LogoResponse> {
    func updateWithLogo<T: LogoNecessary>(list: [T]) -> [T] {
        var logoDic = [String: UIImage?]()
        
        forEach { logoResponse in
            logoDic[logoResponse.ticker] = logoResponse.logo
        }
        
        let resultList = list.map { stock in
            var newStock = stock
            if let logoImage = logoDic[stock.ticker] {
                newStock.image = logoImage
            }
            return newStock
        }
        return resultList
    }
}

