//
//  KISTopVolumeResponse.swift
//  Domain
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public struct KISTopVolumeResponse: Hashable {
    public let rank: String
    public var image: UIImage?
    public let name: String
    public let ticker: String
    public let price: String
    public let fluctuationRate: String
    
    public init(
        rank: String,
        image: UIImage? = nil,
        name: String,
        ticker: String,
        price: String,
        fluctuationRate: String
    ) {
        self.rank = rank
        self.image = image
        self.name = name
        self.ticker = ticker
        self.price = price
        self.fluctuationRate = fluctuationRate
    }
}
