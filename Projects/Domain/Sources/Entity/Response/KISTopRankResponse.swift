//
//  KISTopRankResponse.swift
//  Domain
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public struct KISTopRankResponse {
    public let id: UUID
    public let rank: String
    public var image: UIImage?
    public let name: String
    public let ticker: String
    public let price: String
    public let fluctuationRate: String
    
    public init(
        id: UUID = UUID(),
        rank: String,
        image: UIImage? = nil,
        name: String,
        ticker: String,
        price: String,
        fluctuationRate: String
    ) {
        self.id = id
        self.rank = rank
        self.image = image
        self.name = name
        self.ticker = ticker
        self.price = price
        self.fluctuationRate = fluctuationRate
    }
}

extension KISTopRankResponse: Identifiable, Hashable {}
