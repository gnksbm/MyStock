//
//  KISCurrentPriceResponse.swift
//  Domain
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import UIKit

public struct KISCurrentPriceResponse: Hashable {
    public let id: UUID
    public var image: UIImage?
    public let name: String
    public let ticker: String
    public let price: String
    public let fluctuationRate: String
    
    public init(
        id: UUID = UUID(),
        image: UIImage? = nil,
        name: String,
        ticker: String,
        price: String,
        fluctuationRate: String
    ) {
        self.id = id
        self.image = image
        self.name = name
        self.ticker = ticker
        self.price = price
        self.fluctuationRate = fluctuationRate
    }
}
